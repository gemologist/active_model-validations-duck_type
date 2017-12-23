
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model/validations/duck_type'

Gem::Specification.new do |spec|
  spec.name          = 'active_model-validations-duck_type'
  spec.version       = ActiveModel::Validations::DuckTypeValidator::VERSION
  spec.authors       = ['AdrienSldy']
  spec.email         = ['adriensldy@gmail.com']

  spec.summary       = 'Duck type validators for active model'
  spec.description   = 'Provide an easy way to duck type class entries'
  spec.homepage      = 'https://github.com/gemologist/active_model-validations-duck_type'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.2'
  spec.required_rubygems_version = '>= 1.8.3'

  spec.add_dependency 'activemodel', '~> 5.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52'
end
