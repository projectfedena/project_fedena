class TimetableEntry < ActiveRecord::Base
  belongs_to :timetable_week_day
  belongs_to :course
  belongs_to :period_timing
  belongs_to :subject
end