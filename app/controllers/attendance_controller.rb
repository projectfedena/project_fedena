class AttendanceController < ApplicationController

  before_filter :login_required
 # before_filter :protect_only_from_students, :except => :student_report
#  before_filter :protect_student_profile, :only => [:student_report]
  before_filter :protect_other_student_data

  filter_access_to :all

  def register
    @courses = AcademicYear.this.courses
    @student_attendance_type = Configuration.get("StudentAttendanceType")
    @subjects = Subject.find(:all, :order=> "course_id ASC")
    if request.post?
      case params[:commit]
      when "list_students"
        @attendance_date = params[:attendance][:date]
        if @student_attendance_type == 'Daily'
          @course = Course.find(params[:attendance][:course_id])
          @students = @course.students.active
        else
          @subject = Subject.find(params[:attendance][:subject_id])
          @course = @subject.course
          @students = @course.students.active
        end
      when "submit_att"
        unless params[:attendance][:master_student_ids].nil?
          student_ids = params[:attendance][:master_student_ids]
          student_ids.each do |st|
            Attendance.create(:attendance_date => params[:attendance][:date],
              :student_id => st, :subject_id => params[:attendance][:subject_id])
          end
        end
        flash[:notice] = 'Attendance registered.'
        redirect_to :controller => 'attendance', :action => 'register'
      end
    end
  end

  def register_attendance
    @numlist = params[:student_attendance][:master_student_ids] unless params[:student_attendance].nil?
    unless @numlist == nil
      if request.post?
        @numlist.each do |x|
          @att = Attendance.create(:attendance_date => flash[:attendance_date],
            :student_id => x, :subject_id => flash[:subject_id])
        end
        flash[:notice] = "Attendance Registered"
        redirect_to :action => "index"
      end
    else
      flash[:notice] = "You did not mark any attendance, All students of the class  seems to be present"
      redirect_to :action => "index"
    end
  end

  def index
  end

  def report
    @courses = AcademicYear.this.courses
    @student_attendance_type = Configuration.get("StudentAttendanceType")
    @subjects = Subject.find(:all, :order => "course_id ASC")
    if @student_attendance_type == "Daily"
      if request.post?
        @course = Course.find(params[:student_attendance][:course_id])
        @students = @course.students.active
      end
    else
      if request.post?
        @subject = Subject.find(params[:student_attendance][:subject_id])
        @course = @subject.course
        @students = @course.students.active
      end
    end
  end

  def student_report
    @student = Student.find(params[:id])
    @student_attendance_type = Configuration.get('StudentAttendanceType')
    year = AcademicYear.find(params[:year]) if params[:year]
    year ||= AcademicYear.this
    if @student_attendance_type == 'Daily'
      @student_attendance = Attendance.find_all_by_student_id(params[:id],
        :conditions => "attendance_date >= '#{year.start_date}' AND attendance_date <= '#{year.end_date}'")
    else
      @student_attendance = Attendance.find_all_by_student_id_and_subject_id(params[:id], params[:id1])
      @subject = Subject.find(params[:id1])
    end
  end

end
