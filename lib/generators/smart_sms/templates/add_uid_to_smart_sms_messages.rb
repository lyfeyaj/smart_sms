class AddUidToSmartSmsMessages < ActiveRecord::Migration
  def change
    add_column :smart_sms_messages, :uid, :string
    add_index :smart_sms_messages, :uid
  end
end
