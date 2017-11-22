# encoding: UTF-8
require_relative 'lib/snt/core/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'snt_core'
  s.version     = SNT::VERSION
  s.summary     = ''
  s.description = ''

  s.required_ruby_version     = '>= 2.1.0'

  s.author      = ''
  s.email       = ''
  s.homepage    = ''

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.add_dependency('logging-rails', '>= 0.4.0')
end
