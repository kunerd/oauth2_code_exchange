module Oauth2CodeExchange
  class Configuration
    attr_accessor :google_oauth2, :facebook_oauth2

    def initialize
      @google_oauth2 = generate_provider_config_hash
      @facebook_oauth2 = generate_provider_config_hash
    end

    private
      def generate_provider_config_hash
        {
          client_id: '',
          client_secret: '',
          redirect_uri: ''
        }
      end
  end
end
