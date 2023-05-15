require "faraday"
require "faraday/multipart"
require "active_support/all"
require_relative "openai_api_proxy/version"
require_relative "openai_api_proxy/client"
require_relative "openai_api_proxy/model_client"
require_relative "openai_api_proxy/completion_client"
require_relative "openai_api_proxy/chat_client"
require_relative "openai_api_proxy/embedding_client"
require_relative "openai_api_proxy/file_client"
require_relative "openai_api_proxy/fine_tune_client"

module OpenaiApiProxy
  Error = Class.new StandardError
  ConfigurationError = Class.new Error

  class Configuration
    DEFAULT_API_BASE_URL = "https://api.openai.com/".freeze

    attr_accessor :logger, :api_base_url

    def initialize
      @logger = defined?(Rails) && Rails.respond_to?(:logger) ? Rails.logger : Logger.new($stdout)
      @api_base_url = ENV.fetch "openai_api_base_url", DEFAULT_API_BASE_URL
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

    def api_base_url
      configuration.api_base_url
    end
  end
end
