# frozen_string_literal: true

require_relative "lib/faraday_loop/version"

Gem::Specification.new do |spec|
  spec.name = "faraday_loop"
  spec.version = FaradayLoop::VERSION
  spec.authors = ["n8"]
  spec.email = ["nate@getcensus.com"]

  spec.summary = "A lightweight, generic retry utility extracted from the Faraday Ruby project"
  spec.description = "Faraday Loop provides an easy-to-use mechanism for retrying failed operations in any Ruby application, independent of the full Faraday library."
  spec.homepage = "https://github.com/sutrolabs/faraday_loop"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]
end
