class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.date :attendance_date
      t.references :student
      t.references :subject
    end
  end

  def self.down
    drop_table :attendances
  end
end
