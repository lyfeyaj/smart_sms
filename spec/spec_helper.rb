# encoding: utf-8
require 'rubygems'
require 'bundler/setup'

require 'webmock/rspec'
require 'smart_sms'

require 'database_cleaner'

# WebMock.allow_net_connect!
RSpec.configure do |config|
end

begin
  require 'rails'
rescue LoadError
end

if defined? Rails
  require 'fake_app/rails_app'

  require 'rspec/rails'
end