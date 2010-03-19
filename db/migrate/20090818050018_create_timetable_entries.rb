class CreateTimetableEntries < ActiveRecord::Migration
  def self.up
    create_table :timetable_entries do |t|
      t.references :course
      t.references :timetable_week_day
      t.references :period_timing
      t.references :subject
      t.references :employee
    end
  end

  def self.down
    drop_table :timetable_entries
  end
end
