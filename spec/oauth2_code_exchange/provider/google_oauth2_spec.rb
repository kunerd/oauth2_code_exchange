require 'spec_helper'

describe Oauth2CodeExchange::Provider::GoogleOauth2 do
  let(:code) { 'SOME_CODE_TOKEN' }

  describe '.validate_code' do
    let(:url) { 'https://www.googleapis.com/oauth2/v3/token' }
    let(:client_id) { 'client_id' }
    let(:client_secret) { 'client_secret' }
    let(:redirect_uri) { 'redirect_uri' }
    let(:rest_client) { double }

    before {
      stub_const("RestClient", rest_client)

      Oauth2CodeExchange.configure do |config|
        config.google_oauth2[:client_id] = client_id
        config.google_oauth2[:client_secret] = client_secret
        config.google_oauth2[:redirect_uri] = redirect_uri
      end
    }

    it 'creates correct POST request' do
      expect(rest_client).to receive(:post).with(
        url, {
          code: code,
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri,
          grant_type: 'authorization_code'
        },
        content_type: 'application/x-www-form-urlencoded'
      )
      subject.validate_code(code)
    end

    context 'with valid POST response' do
      let(:access_token) { 'ACCESS_TOKEN' }
      let(:refresh_token) { 'REFRESH_TOKEN' }
      let(:expires_in) { 3920 }
      let(:token_type) { 'Bearer' }

      let(:response_hash) {
        {
          access_token: access_token,
          refresh_token: refresh_token,
          expires_in: expires_in,
          token_type: token_type
        }
      }

      before {
        allow(RestClient).to receive(:post) {
          response_hash.to_json
        }
        subject.validate_code(code)
      }

      it 'gives correct result' do
        expect(subject.access_params).to include response_hash
      end

      describe '.get_user_info' do
        let(:user_info_url) { 'https://www.googleapis.com/plus/v1/people/me' }
        let(:header) {
          {
            Authorization: "Bearer #{access_token}"
          }
        }
        let(:user_info_hash) {
          {
            id: 'SOME_ID',
            email: 'example@example.com'
          }
        }

        it 'creates correct POST request' do
          expect(rest_client).to receive(:get).with(user_info_url, header)
          subject.get_user_info()
        end

        it 'returns received user info' do
          allow(rest_client).to receive(:get) { user_info_hash.to_json }
          expect(subject.get_user_info).to include user_info_hash
        end

        context 'with invalid response' do
          let(:error_hash) {
            {
              error: 'some error msg'
            }
          }

          before {
            allow(rest_client).to receive(:get) { error_hash.to_json }
          }

          it 'returns false' do
            expect(subject.get_user_info).to be false
          end
        end
      end
    end

    context 'with invalid POST response' do
      let(:response_hash) {
        {
          error: 'some error message'
        }
      }

      before {
        allow(RestClient).to receive(:post) {
          response_hash.to_json
        }
      }

      it 'returns false' do
        expect(subject.validate_code(code)).to be false
      end
    end

    describe '.get_user_info' do
      context 'with invalid access_hash' do
        it 'returns false' do
          expect(subject.get_user_info).to be false
        end
      end
    end
  end
end
