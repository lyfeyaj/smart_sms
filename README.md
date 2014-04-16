SmartSMS [![Build Status](https://travis-ci.org/lyfeyaj/smart_sms.png?branch=master)](https://travis-ci.org/lyfeyaj/smart_sms) [![Code Climate](https://codeclimate.com/github/lyfeyaj/smart_sms.png)](https://codeclimate.com/github/lyfeyaj/smart_sms)
===================================

提供在中国境内发送短信, 校验, 以及 ActiveRecord 集成功能

功能特点
--------

* 集成了 [云片网络](http://www.yunpian.com) 的所有短信服务API
  - 发送, 查询模板短信, 通用短信
  - 查询, 修改用户信息
  - 查询默认模板, 自定义模板
  - 新增, 修改, 删除自定义模板
  - 查询用户短信回复
* 集成了 ActiveRecord 支持
* 集成了方便的验证码生成工具
* 强大的配置选项, 几行代码即可集成所有功能

## 安装

    gem install smart_sms

### 或者从 `github` 安装最新的开发版本

    git clone http://github.com/lyfeyaj/smart_sms.git
    cd smart_sms
    rake install

## 使用

### 结合 Rails 使用

##### 配置

``` ruby
SmartSMS.configure do |config|
  config.api_key = nil # 授权 API KEY
  config.api_version = :v1 # API 的版本, 当前仅有v1
  config.template_id = '2' # 指定发送信息时使用的模板
  config.template_value = [:code, :company] # 用于指定信息文本中的可替换内容, 数组形势: [:code, :company]
  config.page_num = 1 # 获取信息时, 指定默认的页数
  config.page_size = 20 # 获取信息时, 一页包含信息数量
  config.company = '云片网' # 默认公司名称
  config.expires_in = 1.hour # 短信验证过期时间
  config.default_interval = 1.day # 查询短信时的默认时间段: end_time - start_time
  config.store_sms_in_local = false # 是否存储SMS信息在本地: true or false
  config.verification_code_algorithm = :simple # 提供三种形式的验证码: `:simple, :middle, :complex`
end
```

##### API 汇总

当在您现有的 model 中声明 `has_sms_verification` 的时候, 您将获得以下方法:
``` ruby
class User < ActiveRecord::Base
  # 在您的Model里面声明这个方法, 以添加SMS短信验证功能
  # moible_column:       mobile 绑定的字段, 用于获取发送短信所需的手机号码, 默认是 :phone
  # verification_column: 验证绑定的字段, 用于判断是否已验证, 
  #
  # Options:
  #   :class_name   自定义的Message类名称. 默认是 `::SmartSMS::Message`
  #   :messages     自定义的Message关联名称.  默认是 `:versions`.
  #
  has_sms_verification
end

# 发送短信验证码
user.deliver # 将会生成一个随机的验证码发送至手机, 并保存在messages表中
user.deliver '内容' # 可以发送指定内容至手机

# 查询历史短信记录
user.messages

# 查询是否已经验证
user.verified? # ture : false

# 校验验证码
user.verify '123456'  # 返回 true 或者 false, 不修改数据库的 verified_at 关联字段
user.verify! '123456' # 返回 true 或者 false, 同时修改数据库的 verified_at 关联字段为当前时间

# 查询验证日期
user.verified_at
```

### 基本用法

## 使用方法和例子
