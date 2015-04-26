require 'rest-client'
require 'json'

module Oauth2CodeExchange
  module Provider
    class GoogleOauth2
      HOST = 'https://www.googleapis.com'
      URL = "#{HOST}/oauth2/v3/token"
      USER_INFO_URL = "#{HOST}/plus/v1/people/me"
      CONTENT_TYPE = 'application/x-www-form-urlencoded'

      attr_reader :access_params

      def initialize
        @client_id = Oauth2CodeExchange.configuration.google_oauth2[:client_id]
        @client_secret = Oauth2CodeExchange.configuration.google_oauth2[:client_secret]
        @redirect_uri = Oauth2CodeExchange.configuration.google_oauth2[:redirect_uri]
      end

      def validate_code(code)
        return false if ( code.nil? || code.empty? )

        params = create_validate_code_params(code)
        content_type = {
          content_type: CONTENT_TYPE
        }
        response = RestClient.post(URL, params, content_type)

        @access_params = create_hash_from_response(response)

        access_params_valid?()
      end

      def get_user_info
        return false unless access_params_valid?()

        header = {
          Authorization: "Bearer #{@access_params[:access_token]}"
        }
        response = RestClient.get(USER_INFO_URL, header)

        @user_info_hash = create_hash_from_response(response)

        return false if hash_contains_errors?(@user_info_hash)
        @user_info_hash
      end

      private

      def hash_contains_errors?(hash)
        return true unless hash
        return true if hash[:error]

        false
      end

      def create_hash_from_response(response)
        return false if (response.nil? || response.empty?)

        JSON.parse(response, symbolize_names: true)
      end

      def create_validate_code_params(code)
        return {
          code: code,
          client_id: @client_id,
          client_secret: @client_secret,
          redirect_uri: @redirect_uri,
          grant_type: 'authorization_code'
        }
      end

      def access_params_valid?
        hash = @access_params
        return false unless hash
        return false if( hash[:access_token].nil? )
        return false if( hash[:expires_in].nil? )
        return false if hash[:token_type] != 'Bearer'

        true
      end
    end
  end
end
