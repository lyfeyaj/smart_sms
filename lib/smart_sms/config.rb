# encoding: utf-8
require 'active_support/configurable'
require 'active_support/core_ext'

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

  # Configuration class
  #
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :api_key # 授权 API KEY
    config_accessor :api_version # API 的版本, 当前仅有v1
    config_accessor :template_id # 指定发送信息时使用的模板
    config_accessor :template_value # 用于指定信息文本中的可替换内容, 数组形势: [:code, :company]
    config_accessor :page_num # 获取信息时, 指定默认的页数
    config_accessor :page_size # 获取信息时, 一页包含信息数量
    config_accessor :company # 默认公司名称
    config_accessor :expires_in # 短信验证过期时间
    config_accessor :default_interval   # 查询短信时的默认时间段: end_time - start_time
    config_accessor :store_sms_in_local # 是否存储SMS信息在本地: true or false
    config_accessor :verification_code_algorithm # :simple, :middle, :complex
  end

  configure do |config|
    config.api_key = nil
    config.api_version = :v1
    config.template_id = '2'
    config.template_value = [:code, :company]
    config.page_num = 1
    config.page_size = 20
    config.company = '云片网'
    config.expires_in = 1.hour
    config.default_interval = 1.day
    config.store_sms_in_local = false
    config.verification_code_algorithm = :simple
  end
end
