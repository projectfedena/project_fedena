class AcademicYearController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def add_course
    render :partial => "course_form"
  end

  def index
    @current_year = AcademicYear.this
    @academic_year = AcademicYear.new(params[:academic_year])
    if request.post?
      @current_academic_year_id = Configuration.find_by_config_key('AcademicYearID')
      @academic_year.previous_year = @current_academic_year_id.config_value.to_i
      if @academic_year.save
        @current_academic_year_id.config_value = @academic_year.id.to_s
        @current_academic_year_id.save
        redirect_to :controller => "academic_year", :action => "migrate_classes"
      end
    end
  end

  def migrate_classes
    year_id = Configuration.find_by_config_key('AcademicYearID')
    prev_year = AcademicYear.find(year_id.config_value.to_i).previous_year
    @courses = Course.find_all_by_academic_year_id(prev_year, :order => "grade, section asc")
    @new_courses = Course.find_all_by_academic_year_id(year_id.config_value)
    if request.post?
      course_id_list = params[:migrate_courses][:course_id] unless params[:migrate_courses].nil?
      unless course_id_list.nil?
        course_id_list.each do |cid|
          c = Course.find(cid)
          new_course = Course.create(:grade => c.grade, :section => c.section,
            :academic_year_id => year_id.config_value)
          subjects = c.subjects
          subjects.each do |sub|
            Subject.create(:name => sub.name,
              :course_id => new_course.id,
              :no_exams => sub.no_exams,
              :max_hours_week => sub.max_hours_week)
          end
        end
      end
      redirect_to :controller => "academic_year", :action => "migrate_students"
    end
  end

  def migrate_students
    current_year = AcademicYear.this
    unless current_year.nil?
      prev_year = current_year.previous_year
      old_courses = Course.find_all_by_academic_year_id(prev_year)
      @old_courses = old_courses.collect do |c|
        st = Student.find_all_by_course_id(c.id, :conditions => "status != \"Former\"")
        c unless st.size == 0
      end
      @old_courses.delete(nil)
    else
      @old_courses = []
    end
    
    if request.post?
      params[:migrate_students][:id].each do |s|
        unless params[:migrate_students][:new_course] == "0"
          student = Student.find(s)
          student.old_courses << student.course
          student.update_attribute(:course_id, params[:migrate_students][:new_course])
        else
          student = Student.find(s)
          student.old_courses << student.course
          student.update_attribute(:status, "Former")
        end
      end
      redirect_to :controller => "academic_year", :action => "migrate_students"
    end
  end

  def list_students
    @students = Student.find_all_by_course_id(params[:course_id], :conditions => "status != \"Former\"")
    new_courses = Course.find_all_by_academic_year_id(AcademicYear.this.id, :order => "grade, section asc")
    @new_courses = new_courses.map {|c| [c.name, c.id]}
    @new_courses << ['Leaving school', 0]
    render :partial => 'student_list'
  end

  def update_courses
    c = Course.new(params[:course])
    c.academic_year_id = Configuration.get("AcademicYearID")
    c.save
    @new_courses = AcademicYear.this.courses
    render :partial => 'course_list'
  end

  def upcoming_exams
    @upcoming_exams = Examination.find(:all, :conditions => "date > #{Date.today} AND date < #{Date.today + 60.days}")
  end

end
