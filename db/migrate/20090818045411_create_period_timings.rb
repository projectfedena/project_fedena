class CreatePeriodTimings < ActiveRecord::Migration
  def self.up
    create_table :period_timings do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.boolean :break
    end
    create_defaults
  end

  def self.down
    drop_table :period_timings
  end

  def self.create_defaults
    PeriodTiming.create(:name => "1", :break => false)
    PeriodTiming.create(:name => "2", :break => false)
    PeriodTiming.create(:name => "Interval", :break => true)
    PeriodTiming.create(:name => "3", :break => false)
    PeriodTiming.create(:name => "4", :break => false)
    PeriodTiming.create(:name => "Lunch", :break => true)
    PeriodTiming.create(:name => "5", :break => false)
    PeriodTiming.create(:name => "6", :break => false)
    PeriodTiming.create(:name => "7", :break => false)
  end
end
