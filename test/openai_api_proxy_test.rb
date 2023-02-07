# frozen_string_literal: true

require "test_helper"

describe OpenaiApiProxy do
  it "has a version number" do
    refute_nil ::OpenaiApiProxy::VERSION
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
end
