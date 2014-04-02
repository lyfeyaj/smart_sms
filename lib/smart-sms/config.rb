#encoding: utf-8
require 'active_support/configurable'

module SmartSMS

  # Configures global settings for SmartSMS
  #   SmartSMS.configure do |config|
  #     config.api_key = 'd63124354422b046081a44466'
  #   end
  def self.configure(&block)
    yield @config ||= SmartSMS::Configuration.new
  end

  # Global settings for SmartSMS
  def self.config
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :api_key
    config_accessor :api_version
    config_accessor :template_id
    config_accessor :template_value
    config_accessor :page_num
    config_accessor :page_size
    config_accessor :company
    config_accessor :store_sms_in_local # :api or :local
  end

  configure do |config|
    config.api_key = nil
    config.api_version = :v1
    config.template_id = '2'
    config.template_value = [:code, :company]
    config.page_num = 1
    config.page_size = 20
    config.company = '云片网'
    config.store_sms_in_local = false
  end
end