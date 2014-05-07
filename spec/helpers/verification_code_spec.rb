# encoding: utf-8
require 'spec_helper'

describe SmartSMS::VerificationCode do
  context 'get random verification code' do
    it 'should return a short code' do
      simple_code = SmartSMS::VerificationCode.random :short
      expect(simple_code.length).to eq(4)
      expect(simple_code).to match(/[0-9]/)
    end

    it 'should return a simple code' do
      simple_code = SmartSMS::VerificationCode.random :simple
      expect(simple_code.length).to eq(6)
      expect(simple_code).to match(/[0-9]/)
    end

    it 'should return a middle code' do
      middle_code = SmartSMS::VerificationCode.random :middle
      expect(middle_code.length).to eq(6)
      expect(middle_code).to match(/[a-zA-Z0-9]/)
    end

    it 'should return a complex code' do
      complex_code = SmartSMS::VerificationCode.random :complex
      expect(complex_code.length).to eq(8)
    end

    it 'should raise NoMethodError when calling non existed algorithm' do
      expect do
        SmartSMS::VerificationCode.random :great_algorithm
      end.to raise_error NoMethodError
    end
  end

  context 'get simple verification code' do
    subject { SmartSMS::VerificationCode.short }

    its(:length) { should == 4 }
    it { should match(/[0-9]/) }
  end

  context 'get simple verification code' do
    subject { SmartSMS::VerificationCode.simple }

    its(:length) { should == 6 }
    it { should match(/[0-9]/) }
  end

  context 'get middle verification code' do
    subject { SmartSMS::VerificationCode.middle }

    its(:length) { should == 6 }
    it { should match(/[a-zA-Z0-9]/) }
  end

  context 'get complex verification code' do
    subject { SmartSMS::VerificationCode.complex }

    its(:length) { should == 8 }
  end
end
