require_relative 'lib/pry_diff_routes/version'

Gem::Specification.new do |spec|
  spec.name          = "pry-diff-routes"
  spec.version       = PryDiffRoutes::VERSION
  spec.authors       = ["Adrian Setyadi"]
  spec.email         = ["a.styd@yahoo.com"]

  spec.summary       = %q{Inspect routes changes in Rails console}
  spec.description   = %q{A Pry plugin to see the difference you made to Rails routes}
  spec.homepage      = "https://github.com/styd/pry-diff-routes"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "pry", "~> 0.12.0"

  spec.add_development_dependency "rails", ">= 5"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
