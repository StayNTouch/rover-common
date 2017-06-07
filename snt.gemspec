# encoding: UTF-8
require_relative 'core/lib/snt/core/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'snt'
  s.version     = SNT::VERSION
  s.author       = ''
  s.email        = ''

  s.summary     = 'Stayntouch'
  s.description = 'Stayntouch'
  s.homepage     = ''

  s.required_ruby_version = '>= 2.1.7'

  s.files        = Dir.glob('{bin,lib}/**/*') + %w(README.md)
  s.bindir        = 'bin'
  s.require_path = 'lib'

  s.add_dependency 'snt_core', s.version
  s.add_dependency 'snt_pms', s.version
  s.add_dependency 'snt_report', s.version
  s.add_dependency 'snt_auth', s.version

  s.add_development_dependency('rake', '>= 0')
end
