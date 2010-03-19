class TimetableController < ApplicationController
  before_filter :login_required
  before_filter :protect_other_student_data
  filter_access_to :all

  def delete_subject
    @errors = {"messages" => []}
    tte=TimetableEntry.update(params[:id], :subject_id => nil)
    @timetable = TimetableEntry.find_all_by_course_id(tte.course_id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def edit
    @errors = {"messages" => []}
    @course = Course.find(params[:id])
    @timetable = TimetableEntry.find_all_by_course_id(params[:id])
    @period_timing = PeriodTiming.find(:all, :conditions => "break = false")
    @day = TimetableWeekDay.find(:all)
    @subjects = Subject.find_all_by_course_id(@course.id)
  end

  def index
  end

  def select_class
    @courses = Course.find_all_by_academic_year_id(AcademicYear.this, :order => "grade, section asc")
    if request.post?
      @course = Course.find(params[:timetable_entry][:course_id])
      @period_timings = PeriodTiming.find(:all, :conditions => "break = false")
      @day = TimetableWeekDay.find(:all)
      @day.each do |d|
        @period_timings.each do |p|
          TimetableEntry.create(:course_id=>@course.id, :timetable_week_day_id => d.id, :period_timing_id => p.id) \
            if TimetableEntry.find_by_course_id_and_timetable_week_day_id_and_period_timing_id(@course.id, d.id, p.id).nil?
        end
     end
      redirect_to :action => "edit", :id => @course.id
    end
  end

  def tt_entry_update
    @errors = {"messages" => []}
    subject = Subject.find(params[:sub_id])
    TimetableEntry.update(params[:tte_id], :subject_id => params[:sub_id])
    @timetable = TimetableEntry.find_all_by_course_id(subject.course_id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def tt_entry_noupdate
    render :update => "error_div_#{params[:tte_id]}", :text => "Cancelled."
  end

  def update_multiple_timetable_entries
    
    subject = Subject.find(params[:subject_id])
    tte_ids = params[:tte_ids].split(",").each {|x| x.to_i}
    course = subject.course
    @validation_problems = {}

    tte_ids.each do |tte_id|
      errors = { "info" => {"sub_id" => subject.id, "tte_id" => tte_id},
                 "messages" => [] }

      # check for weekly subject limit.
      errors["messages"] << "Weekly subject limit reached." \
        if subject.max_hours_week <= TimetableEntry.count(:conditions => "subject_id = #{subject.id}")

      if errors["messages"].empty?
        TimetableEntry.update(tte_id, :subject_id => subject.id)
      else
        @validation_problems[tte_id] = errors
      end
    end

    @timetable = TimetableEntry.find_all_by_course_id(course.id)
    render :partial => "edit_tt_multiple", :with => @timetable
  end

  def view
    @courses = Course.find_all_by_academic_year_id(AcademicYear.this, :order => "grade, section asc")
  end

  def student_view
    student = Student.find(params[:id])
    @course = student.course
    @timetable = TimetableEntry.find_all_by_course_id(@course.id)
    @period_timing = PeriodTiming.find(:all, :conditions => "break = false")
    @day = TimetableWeekDay.find(:all)
    @subjects = Subject.find_all_by_course_id(@course.id)
  end

  def update_timetable_view
    if params[:course_id] == ""
      render :update do |page|
        page.replace_html "timetable_view", :text => ""
      end
      return
    end
    @course = Course.find(params[:course_id])
    @timetable = TimetableEntry.find_all_by_course_id(@course.id)
    @period_timing = PeriodTiming.find(:all, :conditions => "break = false")
    @day = TimetableWeekDay.find(:all)
    @subjects = Subject.find_all_by_course_id(@course.id)

    render :update do |page|
      page.replace_html "timetable_view", :partial => "view_timetable"
    end
  end

end