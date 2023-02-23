require "faraday"
require "faraday/multipart"
require "active_support/all"
require_relative "openai_api_proxy/version"
require_relative "openai_api_proxy/client"
require_relative "openai_api_proxy/model_client"
require_relative "openai_api_proxy/completion_client"
require_relative "openai_api_proxy/file_client"
require_relative "openai_api_proxy/fine_tune_client"

module OpenaiApiProxy
  Error = Class.new StandardError
  ConfigurationError = Class.new Error

  class Configuration
    attr_accessor :logger

    def initialize
      @logger = defined?(Rails) ? Rails.logger : Logger.new($stdout)
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def logger
      configuration.logger
    end
  end
end
