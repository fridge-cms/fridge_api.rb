lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fridge_api/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'sawyer', '~> 0.5.3'
  spec.authors = ["Mike Kruk"]
  spec.description = %q{Simple wrapper for the Fridge API}
  spec.email = ['mike@ripeworks.com']
  spec.files = %w(Rakefile LICENSE.md README.md fridge_api.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/fridge-cms/fridge_api.rb'
  spec.licenses = ['MIT']
  spec.name = 'fridge_api'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.2'
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = "Ruby toolkit for working with the Fridge API"
  spec.version = FridgeApi::VERSION.dup
end
