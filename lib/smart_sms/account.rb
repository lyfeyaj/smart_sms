# encoding: utf-8

module SmartSMS
  # Module that handle user information
  #
  module Account
    module_function

    # 获取用户信息
    #
    def info
      Request.post 'user/get.json'
    end

    # 设置用户信息
    #
    #   * emergency_contact: 紧急联系人
    #   * emergency_mobile:  紧急联系人手机号
    #   * alarm_balance:     短信余额提醒阈值。一天只提示一次
    #
    def set(options = {})
      Request.post 'user/set.json', options
    end
  end
end
