
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jupyter_on_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "jupyter_on_rails"
  spec.version       = JupyterOnRails::VERSION
  spec.authors       = ["Yuki INOUE"]
  spec.email         = ["inoueyuworks@gmail.com"]

  spec.summary       = %q{Integrate jupyter into rails}
  spec.description   = %q{Utilities for integrating jupyter and rails.}
  spec.homepage      = "https://github.com/Yuki-Inoue/jupyter_on_rails"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/Yuki-Inoue/jupyter_on_rails"
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
      .reject { |f| f.match(/\.png$/) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency 'github_changelog_generator'
  spec.add_development_dependency 'bump'

  spec.add_dependency 'iruby'
  spec.add_dependency 'railties'

  spec.add_dependency 'daru'
end
