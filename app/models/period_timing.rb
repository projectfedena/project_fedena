class PeriodTiming < ActiveRecord::Base
  has_many :timetable_entries

  validates_presence_of :name

  def validate
    unless self.start_time.nil? or self.end_time.nil?
      if self.start_time > self.end_time
        errors.add(:end_time, "should be later than start time.")
      end
    end
  end
end
