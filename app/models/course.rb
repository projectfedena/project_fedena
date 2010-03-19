class Course < ActiveRecord::Base
  belongs_to :academic_year
  has_many :students, :class_name => 'Student', :order => 'first_name, middle_name, last_name ASC'
  has_many :subjects
  has_many :timetable_entries
  has_many :subjects_with_exams, :class_name => 'Subject', :conditions => 'no_exams = false'
  has_many :examinations, :through => :subjects

  has_and_belongs_to_many :master_students,
    :class_name => 'Student',
    :join_table => 'students_old_courses'

  validates_presence_of :grade,
    :header_message => "Please Try Again!",
    :message => "name must be entered"
  validates_uniqueness_of :grade,
    :scope => [:section, :academic_year_id],
    :message => "and section are already in the records"

  def examination_types
    self.examinations.collect { |x| x.examination_type }.uniq
  end

  def guardian_email_list
    email_addresses = []
    students = self.students
    students.each do |s|
      email_addresses << s.immediate_contact.email unless s.immediate_contact.nil?
    end
    email_addresses
  end

  def name
    self.grade + ' - ' + self.section
  end

  def student_email_list
    email_addresses = []
    students = self.students
    students.each do |s|
      email_addresses << s.email unless s.email.nil?
    end
    email_addresses
  end

end