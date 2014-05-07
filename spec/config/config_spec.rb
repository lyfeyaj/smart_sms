# encoding: utf-8

require 'spec_helper'

describe SmartSMS::Configuration do
  subject { SmartSMS.config }

  describe 'api_key' do
    context 'by_default' do
      its(:api_key) { should == 'fake_api_key' }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.api_key = 'fdswerfsffsdfdvdsrr23432' }
      end
      its(:api_key) { should == 'fdswerfsffsdfdvdsrr23432' }
      after do
        SmartSMS.configure { |c| c.api_key = 'fake_api_key'  }
      end
    end
  end

  describe 'api_version' do
    context 'by_default' do
      its(:api_version) { should == :v1 }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.api_version = :v2 }
      end
      its(:api_version) { should == :v2 }
      after do
        SmartSMS.configure { |c| c.api_version = :v1 }
      end
    end
  end

  describe 'template_id' do
    context 'by_default' do
      its(:template_id) { should == '2' }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.template_id = '1' }
      end
      its(:template_id) { should == '1' }
      after do
        SmartSMS.configure { |c| c.template_id = '2' }
      end
    end
  end

  describe 'template_value' do
    context 'by_default' do
      its(:template_value) { should == [:code, :company] }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.template_value = [:code] }
      end
      its(:template_value) { should == [:code] }
      after do
        SmartSMS.configure { |c| c.template_value = [:code, :company] }
      end
    end
  end

  describe 'page_num' do
    context 'by_default' do
      its(:page_num) { should == 1 }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.page_num = 2 }
      end
      its(:page_num) { should == 2 }
      after do
        SmartSMS.configure { |c| c.page_num = 1 }
      end
    end
  end

  describe 'page_size' do
    context 'by_default' do
      its(:page_size) { should == 20 }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.page_size = 50 }
      end
      its(:page_size) { should == 50 }
      after do
        SmartSMS.configure { |c| c.page_size = 20 }
      end
    end
  end

  describe 'company' do
    context 'by_default' do
      its(:company) { should == 'Smart SMS' }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.company = 'Edgepeek' }
      end
      its(:company) { should == 'Edgepeek' }
      after do
        SmartSMS.configure { |c| c.company = 'Smart SMS' }
      end
    end
  end

  describe 'expires_in' do
    context 'by_default' do
      its(:expires_in) { should == 1.hour }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.expires_in = 45.minutes }
      end
      its(:expires_in) { should == 45.minutes }
      after do
        SmartSMS.configure { |c| c.expires_in = 1.hour }
      end
    end
  end

  describe 'default_interval' do
    context 'by_default' do
      its(:default_interval) { should == 1.day }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.default_interval = 2.day }
      end
      its(:default_interval) { should == 2.day }
      after do
        SmartSMS.configure { |c| c.default_interval = 1.day }
      end
    end
  end

  describe 'store_sms_in_local' do
    context 'by_default' do
      its(:store_sms_in_local) { should == true }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.store_sms_in_local = false }
      end
      its(:store_sms_in_local) { should == false }
      after do
        SmartSMS.configure { |c| c.store_sms_in_local = true }
      end
    end
  end

  describe 'verification_code_algorithm' do
    context 'by_default' do
      its(:verification_code_algorithm) { should == :simple }
    end
    context 'configured via config block' do
      before do
        SmartSMS.configure { |c| c.verification_code_algorithm = :middle }
      end
      its(:verification_code_algorithm) { should == :middle }
      after do
        SmartSMS.configure { |c| c.verification_code_algorithm = :simple }
      end
    end
  end
end
