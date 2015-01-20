# Model
class User < ActiveRecord::Base
  has_sms_verification
end

# Model with customized columns
class Account < ActiveRecord::Base
  has_sms_verification :mobile, :confirmed_at
end

# Migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :phone
      t.datetime :verified_at
    end

    create_table(:accounts) do |t|
      t.string :mobile
      t.datetime :confirmed_at
    end

    create_table :smart_sms_messages do |t|
      t.string :sid
      t.string :uid
      t.string :mobile
      t.datetime :send_time
      t.text :text
      t.string :code
      t.string :send_status
      t.string :report_status
      t.string :fee
      t.datetime :user_receive_time
      t.text :error_msg
      t.belongs_to :smsable, polymorphic: true
    end
    add_index :smart_sms_messages, :sid
    add_index :smart_sms_messages, :uid
    add_index :smart_sms_messages, [:smsable_id, :smsable_type]
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
