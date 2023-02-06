# frozen_string_literal: true

require_relative "lib/openai_api_proxy/version"

Gem::Specification.new do |spec|
  spec.name = "openai_api_proxy"
  spec.version = OpenaiApiProxy::VERSION
  spec.authors = ["Andersen Fan"]
  spec.email = ["as181920@gmail.com"]

  spec.summary = "openai api client"
  spec.description = "openai api wrapper"
  spec.homepage = "https://github.com/as181920/openai_api_proxy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/as181920/openai_api_proxy"
  spec.metadata["changelog_uri"] = "https://github.com/as181920/openai_api_proxy/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "faraday", "~> 2.7"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest", "~> 5.15"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
end
