require 'rest-client'

module Oauth2CodeExchange
  module Provider

    class FacebookOauth2
      HOST = 'https://graph.facebook.com'
      CODE_EXCHANGE_URL = '/v2.3/oauth/access_token'
      USER_INFO_URI = '/v2.3/me'

      attr_reader :access_params

      def initialize
        @client_id = Oauth2CodeExchange.configuration.facebook_oauth2[:client_id]
        @client_secret = Oauth2CodeExchange.configuration.facebook_oauth2[:client_secret]
        @redirect_uri = Oauth2CodeExchange.configuration.facebook_oauth2[:redirect_uri]
      end

      def validate_code(code)

        url = "#{HOST}#{CODE_EXCHANGE_URL}"
        params = {
          code: code,
          client_id: @client_id,
          client_secret: @client_secret,
          redirect_uri: @redirect_uri
        }
        response = RestClient.get(url, params: params)

        @access_params = create_hash_from_response(response)
      end

      def get_user_info
        url = "#{HOST}#{USER_INFO_URI}"
        hash = {
          access_token: @access_params[:access_token]
        }
        response = RestClient.get(url, params: hash)

        @user_info_hash = create_hash_from_response(response)
      end

      private

      def create_hash_from_response(response)
        return false unless response

        JSON.parse(response, symbolize_names: true)
      end
    end

  end
end
