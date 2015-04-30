require 'spec_helper'

module Oauth2CodeExchange
  module Provider

    describe Factory do
      describe '.create_provider_form_string' do
        let(:create_provider_from_string) { subject.create_provider_from_string(provider_string) }

        context 'google-oauth2' do
          let(:provider_string) { 'google-oauth2' }
          it 'should create a Google OAuth2 provider' do
            expect(create_provider_from_string).to be_a GoogleOauth2
          end
        end

        context 'facebook-oauth2' do
          let(:provider_string) { 'facebook-oauth2' }
          it 'should create a Facebook OAuth2 provider' do
            expect(create_provider_from_string).to be_a FacebookOauth2
          end
        end
      end
    end

  end
end
