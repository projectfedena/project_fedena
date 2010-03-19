class Subject < ActiveRecord::Base
  belongs_to :course
  has_many :examinations
  has_many :examination_types, :through => :examinations
  has_many :attendances
  has_many :timetable_entries

  validates_presence_of :name, :course_id, :max_hours_week
  validates_uniqueness_of :name, :scope => :course_id

  def examination_results
    ExaminationResult.find_all_by_examination_id(self.examinations)
  end
end
