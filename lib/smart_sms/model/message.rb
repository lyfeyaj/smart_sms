module SmartSMS
  # Message model to store sms messages
  #
  class Message < ::ActiveRecord::Base
    self.table_name = 'smart_sms_messages'
    belongs_to :smsable, polymorphic: true
    attr_accessible :sid, :uid, :mobile, :send_time, :text, :code, :send_status, :report_status, :fee, :user_receive_time, :error_msg if SmartSMS.active_record_protected_attributes?
  end
end
