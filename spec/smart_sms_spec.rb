# encoding: utf-8
require 'spec_helper'

describe SmartSMS do
  let(:phone) { '13394738283' }
  let(:content) { '您的验证码是: 432432, 如果此操作与您无关, 请忽略这条短信' }

  describe '#deliver' do
    it 'should deliver a sms message via template send' do

    end

    it 'should deliver a sms message via general send api' do

    end
  end

  describe '#find_by_sid' do
    it 'should the sms message with specific sid' do

    end

    it 'should error message when the sid is not found' do

    end
  end

  describe '#find' do
    it 'should find sms according to parameters' do

    end

    it 'should find nothing when the parameters is invalid' do

    end
  end

  describe '#get_black_word' do
    it 'should get the black word' do

    end
  end

  describe '#get_reply' do
    it 'should get user reply' do

    end
  end
end
