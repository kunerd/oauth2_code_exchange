require "oauth2_code_exchange/version"
require "oauth2_code_exchange/configuration"
require "oauth2_code_exchange/context"
require "oauth2_code_exchange/provider/google_oauth2"
require "oauth2_code_exchange/provider/facebook_oauth2"

module Oauth2CodeExchange

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
