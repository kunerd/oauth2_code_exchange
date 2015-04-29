require 'spec_helper'

describe Oauth2CodeExchange do
  it 'has a version number' do
    expect(Oauth2CodeExchange::VERSION).not_to be nil
  end

  describe ".configure" do
    before do
      Oauth2CodeExchange.configure do |config|
        config.google_oauth2[:client_id] = 'client_id'
        config.facebook_oauth2[:client_id] = 'client_id'
      end
    end

    describe ".google_oauth2.client_id" do
      it "is set correct" do
        expect(Oauth2CodeExchange.configuration.google_oauth2[:client_id]).to eq('client_id')
      end
    end
    
    describe ".google_oauth2.client_id" do
      it "is set correct" do
        expect(Oauth2CodeExchange.configuration.facebook_oauth2[:client_id]).to eq('client_id')
      end
    end
  end
end
