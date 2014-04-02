require 'smart-sms/config'
require 'smart-sms/request'
require 'smart-sms/template'
require 'smart-sms/message_service'
require 'smart-sms/account'

module SmartSMS
  include SmartSMS::MessageService
end