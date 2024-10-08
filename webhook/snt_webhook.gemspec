# encoding: UTF-8

require_relative '../core/lib/snt/core/version.rb'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'snt_webhook'
  s.version = SNT::VERSION
  s.summary = ''
  s.description = ''

  s.required_ruby_version = '>= 2.1.0'

  s.author = ''
  s.email = ''
  s.homepage = ''

  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.add_dependency 'faraday', '~> 1.0'
  s.add_dependency 'faraday_middleware', '~> 1.2.0'
  s.add_dependency 'snt_core', s.version

  s.add_development_dependency 'rake', '>= 0'
end
