module SmartSMS
  # Message service: methods that are used to manage messages
  module MessageService
    def self.included(base)
      base.send :extend, ClassMethods
    end

    # Class methods
    module ClassMethods
      DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S'

      # 发送短信到手机, 默认使用模板发送, 提供通用接口支持
      #
      # * phone:   需要接受短信的手机号码
      # * content: 短信验证内容
      #
      # Options:
      #
      # * method 如若要使用通用短信接口, 需要 :method => :general
      # * tpl_id 选择发送短信的模板, 默认是2
      def deliver(phone, content, options = {})
        if options[:method] == :general
          Request.post 'sms/send.json', mobile: phone, text: content, extend: options[:extend]
        else
          options[:code] = content
          message = parse_content options
          tpl_id = options[:tpl_id] || SmartSMS.config.template_id
          Request.post 'sms/tpl_send.json', tpl_id: tpl_id, mobile: phone, tpl_value: message
        end
      end

      # 根据sid来查询短信记录
      #
      def find_by_sid(sid)
        Request.post 'sms/get.json', sid: sid
      end

      # 参见 `find_messages` 方法
      def find(options = {})
        find_messages 'sms/get.json', options
      end

      # 查询黑名单词语, 用于预先测试可能无法通过审核的模板
      #
      def get_black_word(text = '')
        Request.post 'sms/get_black_word.json', text: text
      end

      # 查询用户回复的短信, 参见 `find_messages` 方法
      def get_reply(options = {})
        find_messages 'sms/get_reply.json', options
      end

      private

      # 批量查短信, 参数:
      #
      # * start_time: 短信提交开始时间
      # * end_time: 短信提交结束时间
      # * page_num: 页码，从1开始
      # * page_size: 每页个数，最大100个
      # * mobile: 接收短信的手机号
      #
      def find_messages(api, options = {})
        options[:end_time]   = Time.now if options[:end_time].blank?
        options[:start_time] = options[:end_time] - SmartSMS.config.default_interval if options[:start_time].blank?
        options[:end_time]   = parse_time(options[:end_time])
        options[:start_time] = parse_time(options[:start_time])
        options[:page_num]  ||= SmartSMS.config.page_num
        options[:page_size] ||= SmartSMS.config.page_size
        Request.post api, options
      end

      def parse_time(time = '')
        if time.present? && time.is_a?(Time)
          time.strftime DATETIME_FORMAT
        elsif time.is_a? String
          time
        else
          ''
        end
      end

      def parse_content(options = {})
        options[:code] ||= ''
        options[:company] ||= SmartSMS.config.company
        SmartSMS.config.template_value.map do |key|
          "##{key}#=#{options[key]}"
        end.join('&')
      end
    end
  end
end
