# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart-sms/version'

Gem::Specification.new do |spec|
  spec.name          = "smart-sms"
  spec.version       = ChinaSMS::VERSION
  spec.authors       = ["lyfeyaj"]
  spec.email         = ["lyfeyaj@gmail.com"]
  spec.description   = %q{A smart sms authentication tool}
  spec.summary       = %q{A smart sms authentication tool}
  spec.homepage      = "https://github.com/lyfeyaj/smart-sms"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
