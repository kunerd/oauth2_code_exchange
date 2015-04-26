require 'spec_helper'

describe Oauth2CodeExchange do
  it 'has a version number' do
    expect(Oauth2CodeExchange::VERSION).not_to be nil
  end

  describe ".configure" do
    before do
      Oauth2CodeExchange.configure do |config|
        config.google_oauth2[:client_id] = 'api_key'
      end
    end

    describe ".google_oauth2.client_id" do
      it "is set correct" do
        expect(Oauth2CodeExchange.configuration.google_oauth2[:client_id]).to eq('api_key')
      end
    end
  end
end
