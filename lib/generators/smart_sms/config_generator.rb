module SmartSms
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<-DESC
Description:
    Copies SmartSMS configuration file to your application's initializer directory.
DESC

      def copy_config_file
        template 'smart_sms_config.rb', 'config/initializers/smart_sms_config.rb'
      end
    end
  end
end
