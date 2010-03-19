class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.integer  :sender
      t.integer  :recipient
      t.string   :subject
      t.string   :message
      t.boolean  :is_read
      t.boolean  :is_deleted_by_sender
      t.boolean  :is_deleted_by_recipient
      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
