# encoding: utf-8
require 'spec_helper'

describe SmartSMS do
  let(:phone) { '13394738283' }
  let(:content) { '您的验证码是: 432432, 如果此操作与您无关, 请忽略这条短信' }

  describe '#deliver' do
    context 'template send api' do
      let(:url) { 'http://yunpian.com/v1/sms/tpl_send.json' }
      subject { SmartSMS.deliver phone, content }

      before do
        stub_request(:post, url).with(
          body: {
            'apikey'    => SmartSMS.config.api_key,
            'mobile'    => phone,
            'tpl_id'    => '2',
            'tpl_value' => "#code#=#{content}&#company#=Smart SMS"
          },
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        ).to_return(
          body: {
            'code' => 0,
            'msg'  => 'OK',
            'result' => {
              'count' => '1',
              'fee'   => '1',
              'sid'   => '592762800'
            }
          }.to_json
        )
      end

      its(['code']) { should eq 0 }
      its(['msg']) { should eq 'OK' }
    end

    context 'general send api' do
      let(:url) { 'http://yunpian.com/v1/sms/send.json' }
      subject { SmartSMS.deliver phone, content, method: :general, extend: true }

      before do
        stub_request(:post, url).with(
          body: {
            'apikey' => SmartSMS.config.api_key,
            'mobile' => phone,
            'extend' => 'true',
            'text'   => content
          },
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        ).to_return(
          body: {
            'code' => 0,
            'msg'  => 'OK',
            'result' => {
              'count' => '1',
              'fee'   => '1',
              'sid'   => '592762800'
            }
          }.to_json
        )
      end

      its(['code']) { should eq 0 }
      its(['msg']) { should eq 'OK' }
    end
  end

  describe '#find_by_sid' do
    context 'with a valid sid' do
      let(:valid_sid) { '1234' }
      let(:url) { 'http://yunpian.com/v1/sms/get.json' }
      subject { SmartSMS.find_by_sid valid_sid }

      before do
        stub_request(:post, url).with(
          body: {
            'apikey' => SmartSMS.config.api_key,
            'sid'    => valid_sid
          },
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        ).to_return(
          body: {
            'code' => 0,
            'msg'  => 'OK',
            'sms'  => {
              'sid'               => valid_sid,
              'mobile'            => phone,
              'send_time'         => '2014-05-08 09:24:08',
              'text'              => content,
              'send_status'       => 'SUCCESS',
              'report_status'     => 'SUCCESS',
              'fee'               => 1,
              'user_receive_time' => '2014-05-08 09:26:23',
              'error_msg'         => nil
            }
          }.to_json
        )
      end

      its(['code']) { should eq 0 }
      its(['msg']) { should eq 'OK' }
      its(:keys) { should include 'sms' }
    end

    context 'with a invalid sid' do
      let(:invalid_sid) { '4362847632874' }
      let(:url) { 'http://yunpian.com/v1/sms/get.json' }
      subject { SmartSMS.find_by_sid invalid_sid }

      before do
        stub_request(:post, url).with(
          body: {
            'apikey' => SmartSMS.config.api_key,
            'sid'    => invalid_sid
          },
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        ).to_return(
          body: {
            'code' => 0,
            'msg'  => 'OK',
            'sms'  => nil
          }.to_json
        )
      end

      its(['code']) { should eq 0 }
      its(['msg']) { should eq 'OK' }
      its(['sms']) { should eq nil }
    end
  end

  describe '#find' do
    let(:url) { 'http://yunpian.com/v1/sms/get.json' }
    subject { SmartSMS.find start_time: '2014-05-07 11:33:36', end_time: '2014-05-08 11:33:36' }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'     => SmartSMS.config.api_key,
          'start_time' => '2014-05-07 11:33:36',
          'end_time'   => '2014-05-08 11:33:36',
          'page_num'   => '1',
          'page_size'  => '20'
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'sms'  => [
            {
              'sid'               => 654805009,
              'mobile'            => phone,
              'send_time'         => '2014-05-08 09:25:58',
              'text'              => content,
              'send_status'       => 'SUCCESS',
              'report_status'     => 'SUCCESS',
              'fee'               => 1,
              'user_receive_time' => '2014-05-08 09:25:58',
              'error_msg'         => nil
            },
            {
              'sid'              => 654804990,
              'mobile'            => phone,
              'send_time'         => '2014-05-08 09:25:56',
              'text'              => content,
              'send_status'       => 'SUCCESS',
              'report_status'     => 'SUCCESS',
              'fee'               => 1,
              'user_receive_time' => '2014-05-08 09:25:57',
              'error_msg'         => nil
            }
          ]
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'sms' }
    its(['sms']) { should_not be_empty }
  end

  describe '#get_black_word' do
    let(:url) { 'http://yunpian.com/v1/sms/get_black_word.json' }
    let(:text) { '这是一条测试短信' }
    subject { SmartSMS.get_black_word text }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey' => SmartSMS.config.api_key,
          'text'   => text
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0, 'msg' => 'OK', 'result' => { 'black_word' => '测试' }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'result' }
  end

  describe '#get_reply' do
    let(:url) { 'http://yunpian.com/v1/sms/get_reply.json' }
    subject { SmartSMS.get_reply start_time: '2014-05-07 11:33:36', end_time: '2014-05-08 11:33:36' }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'     => SmartSMS.config.api_key,
          'start_time' => '2014-05-07 11:33:36',
          'end_time'   => '2014-05-08 11:33:36',
          'page_num'   => '1',
          'page_size'  => '20'
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'sms_reply'  => [
            {
              'id'         => nil,
              'mobile'     => phone,
              'text'       => '哈哈',
              'reply_time' => '2014-05-08 12:03:16',
              'extend'     => '11642'
            }
          ]
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'sms_reply' }
    its(['sms_reply']) { should_not be_empty }
    its(['sms_reply', 0, 'mobile']) { should eq phone }
  end
end
