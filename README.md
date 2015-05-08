SmartSMS
========
[![Build Status](https://travis-ci.org/lyfeyaj/smart_sms.svg?branch=master)](https://travis-ci.org/lyfeyaj/smart_sms)
[![Code Climate](https://codeclimate.com/github/lyfeyaj/smart_sms/badges/gpa.svg)](https://codeclimate.com/github/lyfeyaj/smart_sms)

提供在中国境内发送短信([云片网络](http://www.yunpian.com)), 校验, 集成 ActiveRecord

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

##### 安装

在您的 `Gemfile` 里面添加:

```
gem 'smart_sms'
```

然后, 在 console 中执行下面的代码:

``` bash
# 安装gem
bundle

rails g smart_sms:config # 将会拷贝配置文件至 `config/initializers/smart_sms_config.rb`

# 如果, 需要将所有短信都在本地存储, 则需要将配置文件中的 `store_sms_in_local` 设置为 true, 然后运行
rails g smart_sms:install # 程序将会拷贝相应的 migration 文件到 `db/migrate` 目录下
rake db:migrate
```

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

##### API 汇总(ActiveRecord)

当在您现有的 model 中声明 `has_sms_verification` 的时候, 您将获得以下方法:
``` ruby
class User < ActiveRecord::Base
  # 在您的Model里面声明这个方法, 以添加SMS短信验证功能
  # moible_column:       mobile 绑定的字段, 用于获取发送短信所需的手机号码, 默认是 :phone
  # verification_column: 验证绑定的字段, 用于判断是否已验证, 
  #
  # Options:
  #   :class_name   自定义的Message类名称. 默认是 `SmartSMS::Message`
  #   :messages     自定义的Message关联名称.  默认是 `:messages`.
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

# 查询最新的一条有效短信记录
user.latest_message # 返回有效期内的最近一条短信, 若无则返回nil

# 发送假信息, 方便非国内用户测试用
user.deliver_fake_sms # messages中会保存一条新的短信记录, 但是不会发送短信到手机
```

### 基本用法(不依赖Rails)

##### 设置api_key
``` ruby
SmartSMS.configure { |c| c.api_key = 'fure8423n4324uoj432n4324' }
```

##### 短信

``` ruby

# 发送短信到手机, 默认使用模板发送, 提供通用接口支持
  # phone:   需要接受短信的手机号码
  # content: 短信验证内容
  #
  # Options:
  # :method 如若要使用通用短信接口, 需要 method: :general
  # :tpl_id 选择发送短信的模板, 默认是2
SmartSMS.deliver 13522948742, 'SmartSMS WOW!'
SmartSMS.deliver 13522948742, 'SmartSMS WOW!', tpl_id: 1
SmartSMS.deliver 13522948742, 'SmartSMS WOW!', method: :general # 使用通用短信发送方式, 需申请

# 根据sid来查询短信记录
SmartSMS.find_by_sid 13232
# => {"code"=>0,
# "msg"=>"OK",
# "sms"=>
#  {"sid"=>13232,
#   "mobile"=>"13522948742",
#   "send_time"=>"2014-04-06 13:29:33",
#   "text"=>"您的验证码是668965。如非本人操作，请忽略本短信【SmartSMS】",
#   "send_status"=>"SUCCESS",
#   "report_status"=>"SUCCESS",
#   "fee"=>1,
#   "user_receive_time"=>"2014-04-06 13:29:49",
#   "error_msg"=>nil}}

# 批量查短信, 参数:
#   start_time: 短信提交开始时间
#   end_time: 短信提交结束时间
#   page_num: 页码，从1开始
#   page_size: 每页个数，最大100个
#   mobile: 接收短信的手机号
SmartSMS.find
SmartSMS.find start_time: Time.now.yesterday, end_time: Time.now
SmartSMS.find start_time: Time.now.yesterday, end_time: Time.now, mobile: 13522948742

# 查询屏蔽词
SmartSMS.get_black_word '这是一条测试短信'
# => {"code"=>0, "msg"=>"OK", "result"=>{"black_word"=>"测试"}}

# 查回复的短信, 参数与批量查短信一致, 可以查询用户回复的短信
SmartSMS.get_reply
SmartSMS.get_reply start_time: Time.now.yesterday, end_time: Time.now
SmartSMS.get_reply start_time: Time.now.yesterday, end_time: Time.now, mobile: 13522948742

```

##### 账户

``` ruby

# 获取用户信息
SmartSMS::Account.info
# =>
#{
#  "code" => 0,
#  "msg" => "OK",
#  "user" => {
#    "nick" => "Jacky",
#    "gmt_created" => "2012-09-11 15:14:00",
#    "mobile" => "13764071479",
#    "email" => "jacky@taovip.com",
#    "ip_whitelist" => null,                 //IP白名单，推荐使用
#    "api_version" => "v1",                  //api版本号
#    "send_count" => 0,                      //当天已发送的短信数
#    "balance" => 0,                         //短信剩余条数
#    "alarm_balance" => 0,                   //剩余条数低于该值时提醒
#    "emergency_contact" => "张三",           //紧急联系人
#    "emergency_mobile" => "13812341234"     //紧急联系人电话
#  }
#}

# 设置用户信息
#  emergency_contact: 紧急联系人
#  emergency_mobile:  紧急联系人手机号
#  alarm_balance:     短信余额提醒阈值。一天只提示一次
SmartSMS::Account.set emergency_contact: 13764071479
# =>
#{
#  "code" => 0,
#  "msg" => "OK",
#  "detail" => null
#}

```

##### 模板

``` ruby

# 获取系统默认模板
# Options:
#   tpl_id: 指定tpl_id时返回tpl_id对应的默认模板. 未指定时返回所有默认模板
#
SmartSMS::Template.find_default
SmartSMS::Template.find_default 2

# 获取自定义模板
# Options:
#   tpl_id: 指定tpl_id时返回tpl_id对应的自定义模板. 未指定时返回所有自定义模板
#
SmartSMS::Template.find
SmartSMS::Template.find 3252

# 创建新模板
# 规则请参见: <http://www.yunpian.com/api/tpl.html>
#
SmartSMS::Template.create '您的验证码是: #code#'

# 更新模板, 需指定id和content
#
SmartSMS::Template.update 3252, '您的验证码是: #code#, 【SmartSMS】'

# 删除模板, 需指定id
#
SmartSMS::Template.destroy 3252

```

##### 校验码

``` ruby

# 生成随机校验码
  # 四个选项:
  #   short:   4位随机数字
  #   simple:  6位随机数字, 默认
  #   middle:  6位随机字母, 数字组合
  #   complex: 8位随机字母, 数字, 特殊字符组合

SmartSMS::VerificationCode.random          # => "1708"
SmartSMS::VerificationCode.random :short   # => "141068"
SmartSMS::VerificationCode.random :middle  # => "xey7id"
SmartSMS::VerificationCode.random :complex # => "x+rkag6a"

SmartSMS::VerificationCode.short   # => "1708"
SmartSMS::VerificationCode.simple  # => "141068"
SmartSMS::VerificationCode.middle  # => "xey7id"
SmartSMS::VerificationCode.complex # => "x+rkag6a"

```

## 贡献

+ Fork
+ 创建分支 (git checkout -b my-new-feature)
+ 保存代码 (git commit -am 'Added some feature')
+ 上传到分支 (git push origin my-new-feature)
+ 创建一个新的合并请求

## LICENCE

[MIT](https://github.com/lyfeyaj/smart_sms/blob/master/LICENSE)

## 作者

[Felix Liu](https://github.com/lyfeyaj) 

[作者博客](http://lyfeyaj.com)
