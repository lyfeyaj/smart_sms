class CreateSmartSmsMessages < ActiveRecord::Migration
  def change
    create_table :smart_sms_messages do |t|
      t.string :sid
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
    add_index :smart_sms_messages, [:smsable_id, :smsable_type]
  end
end
