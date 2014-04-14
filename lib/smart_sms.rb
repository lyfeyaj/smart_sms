require 'smart_sms/config'
require 'smart_sms/request'
require 'smart_sms/template'
require 'smart_sms/helpers/fake_sms'
require 'smart_sms/helpers/verification_code'
require 'smart_sms/message_service'
require 'smart_sms/account'

unless defined? ActiveRecord
  begin
    require 'active_record'
  rescue LoadError; end
end

module SmartSMS
  include SmartSMS::MessageService

  def self.active_record_protected_attributes?
    @active_record_protected_attributes ||= ::ActiveRecord::VERSION::MAJOR < 4 || !!defined?(ProtectedAttributes)
  end
end

# Ensure `ProtectedAttributes` gem gets required if it is available before the `Message` class gets loaded in
unless SmartSMS.active_record_protected_attributes?
  SmartSMS.send(:remove_instance_variable, :@active_record_protected_attributes)
  begin
    require 'protected_attributes'
  rescue LoadError; end # will rescue if `ProtectedAttributes` gem is not available
end

require 'smart_sms/has_sms_verification'

ActiveSupport.on_load(:active_record) do
  include SmartSMS::HasSmsVerification
end
