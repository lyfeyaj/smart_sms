require 'rails/generators'
require 'rails/generators/active_record'

module SmartSms
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

    desc <<-EOF
Generates (but does not run) a migration to add a messages table.
You need to set `store_sms_in_local` to `true` in your config file
before running this command
  EOF

    def create_migration_file
      return unless SmartSMS.config.store_sms_in_local
      add_smart_sms_migration('create_smart_sms_messages')
      add_smart_sms_migration('add_uid_to_smart_sms_messages')
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_smart_sms_migration(template)
      migration_dir = File.expand_path('db/migrate')

      unless self.class.migration_exists?(migration_dir, template)
        migration_template "#{template}.rb", "db/migrate/#{template}.rb"
      end
    end
  end
end
