class Examination < ActiveRecord::Base
  belongs_to :examination_type
  belongs_to :subject
  belongs_to :course
  has_many :examination_results

  attr_accessor :course_id

  validates_presence_of :examination_type_id, :subject_id, :date, :max_marks, :weightage

  def average_marks
    results = ExaminationResult.find_all_by_examination_id(self)
    scores = results.collect { |x| x.marks }
    return (scores.sum / scores.size) unless scores.size == 0
    return 0
  end

  def course_id
    s = Subject.find(subject_id)
    s.course_id
  end

  def name
    self.examination_type.name
  end
end
