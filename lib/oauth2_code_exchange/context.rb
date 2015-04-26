module Oauth2CodeExchange
  class Context
    attr_accessor :provider

    def initialize(provider)
      @provider = provider
    end

    def validate_code(code)
      return false unless @provider.validate_code(code)

      @provider.get_user_info
    end
  end
end
