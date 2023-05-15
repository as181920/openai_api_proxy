# frozen_string_literal: true

require "test_helper"

describe OpenaiApiProxy do
  it "has a version number" do
    refute_nil OpenaiApiProxy::VERSION
  end

  it "defines Error" do
    assert_equal OpenaiApiProxy::Error.superclass, StandardError
    assert_equal OpenaiApiProxy::ConfigurationError.superclass, OpenaiApiProxy::Error
  end

  it "support Configuration" do
    assert_instance_of OpenaiApiProxy::Configuration, OpenaiApiProxy.configuration
  end

  it "defines logger" do
    assert_instance_of Logger, OpenaiApiProxy.logger
  end

  it "support custom api base_url on configuration" do
    assert_predicate OpenaiApiProxy.configuration.api_base_url, :present?
  end

  it "read api base url from env" do
    "https://custom_api_host.com/custom_base_path".then do |custom_base_url|
      ENV["openai_api_base_url"] = custom_base_url

      assert_equal custom_base_url, OpenaiApiProxy::Configuration.new.api_base_url
    end
  end
end
