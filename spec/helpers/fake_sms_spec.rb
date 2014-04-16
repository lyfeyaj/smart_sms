# encoding: utf-8
require 'spec_helper'

describe SmartSMS::FakeSMS do
  let(:mobile) { '15338489342' }
  let(:code) { '12345' }
  let(:company) { 'Edgepeek' }
  let(:fake_message) { SmartSMS::FakeSMS.build_fake_sms mobile, code, company }

  it 'should get the right mobile and text' do
    Time.zone = 'Beijing'
    expect(fake_message['mobile']).to eq mobile
    expect(fake_message['text']).to eq "您的验证码是#{code}。如非本人操作，请忽略本短信【#{company}】"
  end
end
