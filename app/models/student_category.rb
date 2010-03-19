class StudentCategory < ActiveRecord::Base
  has_many :students

  validates_presence_of :name
  validates_uniqueness_of :name

  def before_destroy
    students = Student.find_all_by_student_category_id self
    students.each { |s| s.student_category_id = nil }
  end
  
end
