class CourseController < ApplicationController
  before_filter :login_required
 # before_filter :only_admin_allowed
 filter_access_to :all
  
  def create
    @course = Course.new(params[:course])
    current_academic_yr = Configuration.get('AcademicYearID')
    @course.academic_year_id = current_academic_yr
    @courses = Course.find_all_by_academic_year_id(current_academic_yr, :order => "grade, section asc")
    if request.post? and @course.save
      flash[:notice] = "Course created."
      redirect_to :controller => "course", :action => "create"
    end
  end

  def delete
    course = Course.find(params[:id])
   
    if course.students.empty? and course.subjects.empty? and course.timetable_entries.empty?
      Course.destroy(params[:id])
      @courses = AcademicYear.this.courses
      flash[:notice]="Course deleted successfully"
      redirect_to :controller=>"course", :action=>"create"
    else
      @courses = AcademicYear.this.courses
      flash[:notice]="Course was not deleted because it may be used elsewhere!."
      redirect_to :controller=>"course", :action=>"create"
    end
  end
  
  def edit
    @course = Course.find(params[:id])
    if request.post? and @course.update_attributes(params[:course])
      flash[:notice] = "Course updated."
      redirect_to :controller => "course", :action => "create"
    end
  end

  def email
    @course = Course.find(params[:id])
    if request.post?
      recipient_list = []
      case params['email']['recipients']
      when 'Students'
        recipient_list << @course.student_email_list
      when 'Guardians'
        recipient_list << @course.guardian_email_list
      when 'Students & Guardians'
        recipient_list += @course.student_email_list + @course.guardian_email_list
      end
      unless recipient_list.empty?
        recipients = recipient_list.join(', ')
        FedenaMailer::deliver_email(recipients, params[:email][:subject], params[:email][:message])
        flash[:notice] = "Mail sent to #{recipients}"
        redirect_to :controller => 'user', :action => 'dashboard'
      end
    end
  end

  def upcoming_exams
    @course = Course.find(params[:id])
    @upcoming_exams = @course.examinations(:conditions => "date >= #{Date.today} AND date <= #{Date.today + 60.days}")
  end

  def view
    @course = Course.find(params[:id])
    @students = @course.students
  end

end