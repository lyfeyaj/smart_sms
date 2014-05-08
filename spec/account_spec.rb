# encoding: utf-8
require 'spec_helper'

describe SmartSMS::Template do

  describe '#info' do
    let(:url) { 'http://yunpian.com/v1/user/get.json' }
    subject { SmartSMS::Account.info }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey' => SmartSMS.config.api_key
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'user' => {
            'nick'              => 'LYFEYAJ',
            'gmt_created'       => '2014-04-01 14:00:52',
            'mobile'            => '13096953122',
            'email'             => 'lyfeyaj@gmail.com',
            'ip_whitelist'      => nil,
            'api_version'       => 'v1',
            'alarm_balance'     => 150,
            'emergency_contact' => '',
            'emergency_mobile'  => '',
            'balance'           => 676
          }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'user' }
  end

  describe '#set' do
    let(:url) { 'http://yunpian.com/v1/user/set.json' }
    let(:emergency_contact) { 'Felix Liu' }
    let(:emergency_mobile)  { '13394738283' }
    let(:alarm_balance)     { '100' }
    subject do
      SmartSMS::Account.set(
        emergency_contact: emergency_contact,
        emergency_mobile: emergency_mobile,
        alarm_balance: alarm_balance
      )
    end

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'            => SmartSMS.config.api_key,
          'emergency_contact' => emergency_contact,
          'emergency_mobile'  => emergency_mobile,
          'alarm_balance'     => alarm_balance
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code'   => 0,
          'msg'    => 'OK',
          'detail' => nil
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'detail' }
  end
end
