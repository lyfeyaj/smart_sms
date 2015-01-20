# encoding: utf-8
begin
  require 'rails'
rescue LoadError
end

require 'rubygems'
require 'bundler/setup'
# Bundler.require

require 'rspec/its'
require 'webmock/rspec'

require 'smart_sms'

require 'database_cleaner'

# WebMock.allow_net_connect!

if defined? Rails
  require 'fake_app/rails_app'

  require 'rspec/rails'
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
