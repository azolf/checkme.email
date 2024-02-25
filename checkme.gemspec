# frozen_string_literal: true

require_relative "lib/checkme/version"

Gem::Specification.new do |spec|
  spec.name = "checkme"
  spec.version = Checkme::VERSION
  spec.authors = ["Amirhosein Zolfaghari"]
  spec.email = ["amirhosein.zlf@gmail.com"]

  spec.summary = "Check email addresses to be valid"
  spec.description = "Check email addresses to be valid"
  spec.homepage = "https://checkme.email"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.3"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://checkme.email"
  spec.metadata["changelog_uri"] = "https://checkme.email"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "midi-smtp-server"
  spec.add_dependency "thor"
  spec.add_dependency "truemail"
  spec.add_dependency "zeitwerk"
  spec.add_dependency 'mail'
  spec.add_dependency 'standalone_migrations'
  spec.add_dependency 'pg'
  spec.add_dependency 'activerecord'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
