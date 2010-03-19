class CreateTimetableWeekDays < ActiveRecord::Migration
  def self.up
    create_table :timetable_week_days do |t|
      t.column   :name, :string
    end
    create_default
  end

  def self.down
    drop_table :timetable_week_days
  end

  def self.create_default
    day_list = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    day_list.each { |c| TimetableWeekDay.create(:name => c) }
  end

end
