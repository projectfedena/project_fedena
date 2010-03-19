class Student < ActiveRecord::Base
  belongs_to :country
  belongs_to :nationality, :class_name => 'Country'
  belongs_to :course
  belongs_to :student_category
  has_many :examination_results, :dependent => :destroy
  has_many :guardians, :dependent => :destroy
  has_and_belongs_to_many :old_courses, :class_name => 'Course', :join_table => 'students_old_courses'

  named_scope :active, :conditions => {:status => 'Active'}

  validates_presence_of :admission_no, :admission_date, :first_name, :course_id, :date_of_birth
  validates_uniqueness_of :admission_no

  def validate
    errors.add(:date_of_birth, "cannot be a future date.") \
      if self.date_of_birth > Date.today \
        unless self.date_of_birth.nil?
  end

  def image_file=(input_data)
    return if input_data.blank?
    self.photo_filename     = input_data.original_filename
    self.photo_content_type = input_data.content_type.chomp
    self.photo_data         = input_data.read
  end

  def all_courses
    self.old_courses + self.course.to_a
  end

  def annual_weighted_marks(year)
    course = self.old_courses.find_by_academic_year_id(year)
    course ||= self.course
    annual_average_marks_for_a_course(course)
  end

  # Returns a %-age value when available, and nil if no weightage is given.
  def annual_weighted_marks_for_a_subject(subject)
    results = ExaminationResult.find_all_by_student_id_and_examination_id(self.id, subject.examinations)
    weighted_marks_subject = 0; weighted_marks_total = 0
    results.each do |r|
      weighted_marks_subject += r.score_weightage
      weighted_marks_total += r.weightage
    end
    return (weighted_marks_subject * 100.0 / weighted_marks_total) unless weighted_marks_total == 0
    return nil
  end

  def annual_average_marks_for_a_course(course)
    subjects = course.subjects.find_all_by_no_exams(false)
    marks = 0
    sub_count = 0
    subjects.each do |subject|
      m = annual_weighted_marks_for_a_subject(subject)
      unless m.nil?
        marks += m
        sub_count += 1 unless m == 0
      end
    end
    sub_count == 0 ? 0 : marks/sub_count
  end

  def examination_types
    self.course.examination_types
  end

  def examtype_average_marks(exam_type, course)
    subjects = course.subjects.find_all_by_no_exams(false)
    marks = 0
    sub_count = 0
    subjects.each do |s|
      exam = Examination.find_by_examination_type_id_and_subject_id(exam_type, s)
      unless exam.nil?
        score = ExaminationResult.find_by_student_id_and_examination_id(self, exam)
        unless score.nil?
          unless score.percentage_marks == 0
            marks += score.percentage_marks
            sub_count += 1
          end
        end
      end
    end
    return (marks.to_f / sub_count) unless sub_count == 0
    return -1
  end

  def first_and_last_name
    self.first_name + ' ' + self.last_name.to_s
  end

  def full_name
    self.first_name + ' ' + self.middle_name.to_s + ' ' + self.last_name.to_s
  end

  def gender_as_text
    self.gender ? 'Male' : 'Female'
  end

  def immediate_contact
    Guardian.find(self.immediate_contact_id) unless self.immediate_contact_id.nil?
  end

  def next_student
    next_st = self.course.students.first(:conditions => "admission_no > #{self.admission_no}", :order => "admission_no ASC")
    next_st ||= course.students.first(:order => "admission_no ASC")
  end

  def previous_student
    prev_st = self.course.students.first(:conditions => "admission_no < #{self.admission_no}", :order => "admission_no DESC")
    prev_st ||= course.students.first(:order => "admission_no DESC")
    prev_st ||= self.course.students.first(:order => "admission_no DESC")
  end

  def subjects
    self.course.subjects
  end

  def subjects_with_exams
    self.course.subjects_with_exams
  end

  def self.next_admission_no
    self.count == 0 ? 1 : maximum('admission_no') + 1
  end
  def get_fee_strucure_elements
    elements = FinanceFeeStructureElement.get_all_fee_components
    elements[:all] + elements[:by_course] + elements[:by_category] + elements[:by_course_and_category]
  end
  def user
    User.find_by_username self.admission_no
  end

end