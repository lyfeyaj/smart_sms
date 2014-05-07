# encoding: utf-8
begin
  require 'rails'
rescue LoadError => e
  puts e
end

require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'webmock/rspec'
require 'smart_sms'

require 'database_cleaner'

# WebMock.allow_net_connect!
RSpec.configure do |config|
end


if defined? Rails
  require 'fake_app/rails_app'

  require 'rspec/rails'
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
