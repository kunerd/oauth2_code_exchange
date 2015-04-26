require 'spec_helper'

describe Oauth2CodeExchange::Context do
  let(:provider) { double }
  subject(:service) { Oauth2CodeExchange::Context.new( provider ) }

  describe '.validate_code' do
    subject(:validate_code) { service.validate_code(code) }

    let(:code) { 'SOME_CODE_TOKEN' }
    let(:access_token) { double }
    let(:content_type) { 'application/x-www-form-urlencoded' }
    let(:validation_url) { 'www.some-provider.com/validation' }

    it "calls 'provider.validate_code'" do
      expect(provider).to receive(:validate_code).with(code)
      validate_code
    end

    context 'with valid code' do
      before { allow(provider).to receive(:validate_code).with(code) {true} }

      it "calls 'provider.get_user_info'" do
        expect(provider).to receive(:get_user_info)
        validate_code
      end

      context 'with valid user_info' do
        let(:user_info) { double }
        before { allow(provider).to receive(:get_user_info) { user_info } }

        it { is_expected.to be user_info }
      end
    end

    context 'with invalid code' do
      before { allow(provider).to receive(:validate_code).with(code) {false} }

      it { is_expected.to be false }
    end
  end
end
