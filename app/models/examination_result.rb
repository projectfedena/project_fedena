class ExaminationResult < ActiveRecord::Base
  belongs_to :examination
  belongs_to :student
  belongs_to :grading

  def before_save
    self.marks = 0 if self.marks.nil?
  end

  def maximum_marks
    self.examination.max_marks.to_f
  end

  def name
    self.examination.name
  end

  def weightage
    self.examination.weightage
  end

  def percentage_marks
    self.marks.to_f * 100 / self.maximum_marks
  end

  def score_weightage
    self.weightage.to_f * self.marks.to_f / self.maximum_marks
  end
end
