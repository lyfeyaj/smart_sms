module SmartSMS
  class Message < ::ActiveRecord::Base
    belongs_to :smsable, polymorphic: true
  end
end
