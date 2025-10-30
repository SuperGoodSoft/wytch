# frozen_string_literal: true

require_relative "lib/wytch/version"

Gem::Specification.new do |spec|
  spec.name = "wytch"
  spec.version = Wytch::VERSION
  spec.authors = ["Jared Norman"]
  spec.email = ["jared@super.gd"]

  spec.summary = "A minimal static site generator"
  spec.description = "A minimal static site generator"
  spec.homepage = "https://github.com/SuperGoodSoft/wytch"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/SuperGoodSoft/wytch"
  spec.metadata["changelog_uri"] = "https://github.com/SuperGoodSoft/wytch/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "puma", "~> 6.4"
  spec.add_dependency "rack", "~> 3.1"
  spec.add_dependency "thor", "~> 1.4"
  spec.add_dependency "zeitwerk", "~> 2.6"
end
