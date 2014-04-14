# encoding: utf-8
require 'net/http'
require 'active_support/json'

module SmartSMS
  # Module that manage requests
  module Request
    module_function

    def post(api, options = {})
      options[:apikey] = SmartSMS.config.api_key
      uri = URI.join(base_url, api)
      res = Net::HTTP.post_form(uri, options)
      result res.body
    end

    def get(api, options = {})
      options[:apikey] = SmartSMS.config.api_key
      uri = URI.join(base_url, api)
      result Net::HTTP.get(uri, options)
    end

    private

    def result(body)
      begin
        ActiveSupport::JSON.decode body
      rescue => e
        {
          code: 502,
          msg: '内容解析错误',
          detail: e.to_s
        }
      end
    end

    def base_url
      "http://yunpian.com/#{SmartSMS.config.api_version}/"
    end
  end
end
