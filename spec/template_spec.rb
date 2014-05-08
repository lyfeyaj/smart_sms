# encoding: utf-8
require 'spec_helper'

describe SmartSMS::Template do

  describe '#find_default' do
    let(:url) { 'http://yunpian.com/v1/tpl/get_default.json' }
    let(:tpl_id) { '1' }
    subject { SmartSMS::Template.find_default tpl_id }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'    => SmartSMS.config.api_key,
          'tpl_id'    => tpl_id
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'template' => {
            'tpl_id'       => tpl_id,
            'tpl_content'  => '您的验证码是#code#【#company#】',
            'check_status' => 'SUCCESS',
            'reason'       => nil
          }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'template' }
  end

  describe '#find' do
    let(:url) { 'http://yunpian.com/v1/tpl/get.json' }
    let(:tpl_id) { '325207' }
    subject { SmartSMS::Template.find tpl_id }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'    => SmartSMS.config.api_key,
          'tpl_id'    => tpl_id
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'template' => {
            'tpl_id'       => tpl_id,
            'tpl_content'  => '您的验证码是#code#【#company#】',
            'check_status' => 'SUCCESS',
            'reason'       => nil
          }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'template' }
  end

  describe '#create' do
    let(:url) { 'http://yunpian.com/v1/tpl/add.json' }
    let(:tpl_content) { '您的验证码是: #code#' }
    subject { SmartSMS::Template.create tpl_content }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'      => SmartSMS.config.api_key,
          'tpl_content' => tpl_content
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'template' => {
            'tpl_id'       => '43243242',
            'tpl_content'  => tpl_content,
            'check_status' => 'SUCCESS',
            'reason'       => nil
          }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'template' }
  end

  describe '#update' do
    let(:url) { 'http://yunpian.com/v1/tpl/update.json' }
    let(:tpl_id) { '43243242' }
    let(:tpl_content) { '您的验证码是: #code#' }
    subject { SmartSMS::Template.update tpl_id, tpl_content }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey'      => SmartSMS.config.api_key,
          'tpl_id'      => tpl_id,
          'tpl_content' => tpl_content
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'template' => {
            'tpl_id'       => tpl_id,
            'tpl_content'  => tpl_content,
            'check_status' => 'SUCCESS',
            'reason'       => nil
          }
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'template' }
  end

  describe '#destroy' do
    let(:url) { 'http://yunpian.com/v1/tpl/del.json' }
    let(:tpl_id) { '43243242' }
    subject { SmartSMS::Template.destroy tpl_id }

    before do
      stub_request(:post, url).with(
        body: {
          'apikey' => SmartSMS.config.api_key,
          'tpl_id' => tpl_id
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      ).to_return(
        body: {
          'code' => 0,
          'msg'  => 'OK',
          'detail' => nil
        }.to_json
      )
    end

    its(['code']) { should eq 0 }
    its(['msg']) { should eq 'OK' }
    its(:keys) { should include 'detail' }
    its(['detail']) { should be_nil }
  end
end
