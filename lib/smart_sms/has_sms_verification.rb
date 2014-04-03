require File.expand_path('../model/message.rb', __FILE__) if SmartSMS.config.store_sms_in_local

module SmartSMS
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_sms_verification moible_column, verification_column, options = {}
        send :include, InstanceMethods

        # 用于判断是否已经验证的字段, Datetime 类型, 例如 :verified_at
        class_attribute :sms_verification_column
        self.sms_verification_column = verification_column

        class_attribute :sms_mobile_column
        self.sms_mobile_column = moible_column

        if SmartSMS.config.store_sms_in_local

          class_attribute :messages_association_name
          self.messages_association_name = options[:messages] || :messages

          class_attribute :message_class_name
          self.message_class_name = options[:class_name] || 'SmartSMS::Message'

          if ::ActiveRecord::VERSION::MAJOR >= 4 # `has_many` syntax for specifying order uses a lambda in Rails 4
            has_many self.messages_association_name,
              lambda { order("send_time ASC") },
              :class_name => self.message_class_name, :as => :item
          else
            has_many self.messages_association_name,
              :class_name => self.message_class_name,
              :as         => :item,
              :order      => "send_time ASC"
          end

        end
      end

      module InstanceMethods
        def verify! code
          if SmartSMS.config.store_sms_in_local
            sms = self.send(self.class.messages_association_name).last
            return false if sms.blank?
            sms.code == code.to_s
          else
            sms = SmartSMS.find(
              start_time: (Time.now - 1.hour),
              end_time: Time.now,
              mobile: self.send(self.class.sms_mobile_column)
            )['sms'].first
            return false if sms.blank?
            !!(sms['text'] =~ /#{code}/)
          end
        end

        def verified?
          self[self.class.sms_verification_column].present?
        end

        def verified_at
          self[self.class.sms_verification_column]
        end

        def deliver text = random_verification_code
          result = SmartSMS.deliver self.send(self.class.sms_mobile_column), text
          if result['code'] == 0
            sms = SmartSMS.find_by_sid(result['result']['sid'])['sms']
            if SmartSMS.config.store_sms_in_local
              message = self.send(self.messages_association_name).build sms
              message.code = text
              message.save
            else
              sms
            end
          else
            self.errors.add :deliver, result
            false
          end
        end

        def random_verification_code
          case SmartSMS.config.verification_code_algorithm
          when :simple
            SmartSMS::VerificationCode.simple
          when :middle
            SmartSMS::VerificationCode.middle
          when :complex
            SmartSMS::VerificationCode.complex
          end
        end

      end
    end
  end
end