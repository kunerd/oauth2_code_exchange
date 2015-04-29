require 'spec_helper'

module Oauth2CodeExchange
  module Provider
    describe FacebookOauth2 do
      let(:code) { 'SOME_CODE' }
      let(:client_id) { 'client_id' }
      let(:client_secret) { 'client_secret' }
      let(:redirect_uri) { 'redirect_uri' }
      let(:rest_client) { double }

      before {
        stub_const("RestClient", rest_client)

        Oauth2CodeExchange.configure do |config|
          config.facebook_oauth2[:client_id] = client_id
          config.facebook_oauth2[:client_secret] = client_secret
          config.facebook_oauth2[:redirect_uri] = redirect_uri
        end
      }

      describe '.validate_code' do
        let(:code_exchange_url) { 'https://graph.facebook.com/v2.3/oauth/access_token' }
        let(:exchange_hash) {
          {
           code: code,
           client_id: client_id,
           client_secret: client_secret,
           redirect_uri: redirect_uri
          }
        }

        it 'creates correct GET request' do
          expect(rest_client).to receive(:get).with(code_exchange_url, params: exchange_hash)
          subject.validate_code(code)
        end

        context 'with valid POST response' do
          let(:access_token) { 'ACCESS_TOKEN' }
          let(:expires_in) { 3920 }
          let(:token_type) { 'Bearer' }

          let(:response_hash) {
            {
              access_token: access_token,
              expires_in: expires_in,
              token_type: token_type
            }
          }

          before {
            allow(RestClient).to receive(:get) {
              response_hash.to_json
            }
            subject.validate_code(code)
          }

          it 'gives correct result' do
            expect(subject.access_params).to include response_hash
          end

          describe '.get_user_info' do
            let(:user_info_url) { 'https://graph.facebook.com/v2.3/me' }
            let(:hash) {
              {
                access_token: "#{access_token}"
              }
            }
            let(:user_info_hash) {
              {
                id: 'SOME_ID',
                email: 'example@example.com'
              }
            }

            it 'creates correct GET request' do
              expect(rest_client).to receive(:get).with(user_info_url, params: hash)
              subject.get_user_info()
            end

            it 'returns received user info' do
              allow(rest_client).to receive(:get) { user_info_hash.to_json }
              expect(subject.get_user_info).to include user_info_hash
            end

            # context 'with invalid response' do
            #   let(:error_hash) {
            #     {
            #       error: 'some error msg'
            #     }
            #   }
            #
            #   before {
            #     allow(rest_client).to receive(:get) { error_hash.to_json }
            #   }
            #
            #   it 'returns false' do
            #     expect(subject.get_user_info).to be false
            #   end
            # end
          end
        end
      end
    end
  end
end
