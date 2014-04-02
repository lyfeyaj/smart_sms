#encoding: utf-8

module SmartSMS
  module Account
    extend self

    def info
      Request.post 'user/get.json'
    end

    # Set account information
    #   emergency_contact: 紧急联系人
    #   emergency_mobile:  紧急联系人手机号
    #   alarm_balance:     短信余额提醒阈值。一天只提示一次
    def set options = {}
      Request.post 'tpl/get.json', options
    end
  end
end