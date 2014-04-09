# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_sms/version'

Gem::Specification.new do |s|
  s.name          = "smart_sms"
  s.version       = SmartSMS::VERSION
  s.authors       = ["lyfeyaj"]
  s.email         = ["lyfeyaj@gmail.com"]
  s.description   = %q{A smart sms verification tool}
  s.summary       = %q{A smart sms verification tool used in China and integrate with yunpian.com}
  s.homepage      = "https://github.com/lyfeyaj/smart_sms"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord', ['>= 3.0', '< 5.0']
  s.add_dependency 'activesupport', ['>= 3.0', '< 5.0']

  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'database_cleaner', ['~> 1.2.0']
  s.add_development_dependency "webmock", ['~> 1.17.0']
end
