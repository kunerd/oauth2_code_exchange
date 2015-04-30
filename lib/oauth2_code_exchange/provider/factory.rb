module Oauth2CodeExchange
  module Provider
    class Factory

      def create_provider_from_string(provider)
        case provider
        when 'google-oauth2'
          return GoogleOauth2.new
        when 'facebook-oauth2'
          return FacebookOauth2.new
        else
          return nil
        end
      end
    end

  end
end
