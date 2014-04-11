# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), 'model/message'))

module SmartSMS
  module HasSmsVerification

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      # 在您的Model里面声明这个方法, 以添加SMS短信验证功能
      # moible_column:       mobile 绑定的字段, 用于发送短信
      # verification_column: 验证绑定的字段, 用于判断是否以验证
      #
      # Options:
      # :class_name   自定义的Message类名称. 默认是 `::SmartSMS::Message`
      # :messages     自定义的Message关联名称.  默认是 `:versions`.
      #
      def has_sms_verification moible_column = :phone, verification_column = :verified_at, options = {}
        send :include, InstanceMethods

        # 用于判断是否已经验证的字段, Datetime 类型, 例如 :verified_at
        class_attribute :sms_verification_column
        self.sms_verification_column = verification_column

        class_attribute :sms_mobile_column
        self.sms_mobile_column = moible_column

        class_attribute :verify_regexp
        self.verify_regexp = /(【.+】|[^a-zA-Z0-9\.\-\+_])/ # 用于抽取校验码, 如若修改过模板, 可能需要修改这个这正则

        if SmartSMS.config.store_sms_in_local

          class_attribute :messages_association_name
          self.messages_association_name = options[:messages] || :messages

          class_attribute :message_class_name
          self.message_class_name = options[:class_name] || '::SmartSMS::Message'

          if ::ActiveRecord::VERSION::MAJOR >= 4 # Rails 4 里面, 在 `has_many` 声明中定义order lambda的语法
            has_many self.messages_association_name,
              lambda { order("send_time ASC") },
              :class_name => self.message_class_name, :as => :smsable
          else
            has_many self.messages_association_name,
              :class_name => self.message_class_name,
              :as         => :smsable,
              :order      => "send_time ASC"
          end

        end
      end

      module InstanceMethods

        # 非安全verify!方法, 验证成功后会存储成功的结果到数据表中
        def verify! code
          result = verify code
          if result
            self.send("#{self.class.sms_verification_column}=", Time.now)
            self.save(validate: false)
          end
        end

        # 安全verify方法, 用于校验短信验证码是否正确, 返回: true 或 false
        #
        def verify code
          sms = latest_message
          return false if sms.blank?
          if SmartSMS.config.store_sms_in_local
            sms.code == code.to_s
          else
            sms['text'].gsub(self.class.verify_regexp, '') == code.to_s
          end
        end

        # 判断是否已经验证成功
        #
        def verified?
          verified_at.present?
        end

        def verified_at
          self[self.class.sms_verification_column]
        end

        # 获取最新的一条有效短信记录
        #
        def latest_message
          end_time = Time.now
          start_time = end_time - SmartSMS.config.expires_in # the verification code will be expired within 1 hour
          if SmartSMS.config.store_sms_in_local
            self.send(self.class.messages_association_name)
                .where("send_time >= ? and send_time <= ?", start_time, end_time)
                .last
          else
            result = SmartSMS.find(
              start_time: start_time,
              end_time: end_time,
              mobile: self.send(self.class.sms_mobile_column),
              page_size: 1
            )
            result['sms'].first
          end
        end

        # 发送短信至手机
        #
        def deliver text = SmartSMS::VerificationCode.random
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

        def deliver_fake_sms text = SmartSMS::VerificationCode.random
          sms = SmartSMS::FakeSMS.build_fake_sms self.send(self.class.sms_mobile_column), text, SmartSMS.config.company
          if SmartSMS.config.store_sms_in_local
            message = self.send(self.messages_association_name).build sms
            message.code = text
            message.save
          else
            sms
          end
        end
      end
    end
  end
end