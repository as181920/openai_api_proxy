# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "openai_api_proxy"

require "minitest/autorun"
require "minitest/mock"
require "mocha/minitest"
require "webmock/minitest"

require "minitest/reporters"
Minitest::Reporters.use!

OpenaiApiProxy.configuration.logger = Logger.new(nil)
