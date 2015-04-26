require 'spec_helper'

module Oauth2CodeExchange
  describe Configuration do

    let(:empty_hash) {
      {
        client_id: '',
        client_secret: '',
        redirect_uri: ''
      }
    }
    context "default" do
      it ".google_oauth2 is empty" do
        expect(subject.google_oauth2).to include empty_hash
      end
    end

    describe ".google_oauth2" do
      let(:google_oauth2) { subject.google_oauth2 }

      it "can set client_id" do
        google_oauth2[:client_id] = 1
        expect(google_oauth2[:client_id]).to eq 1
      end

      it "can set client_secret" do
        google_oauth2[:client_secret] = 1
        expect(google_oauth2[:client_secret]).to eq 1
      end

    end
    # describe ".provider" do
    #   it "" do
    #     expect(config.provider.google_oauth2.api_key).to eq('api_key')
    #   end
    #
    #   it "can set value" do
    #     config = Configuration.new
    #     config.provider.google_oauth2.api_key = 'new_api_key'
    #     expect(config.provider.google_oauth2.api_key).to eq('new_api_key')
    #   end
    # end
  end
end
