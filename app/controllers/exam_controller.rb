class ExamController < ApplicationController
  before_filter :login_required
#  before_filter :only_admin_allowed, :except => :index
  filter_access_to :all

  def create
    @courses = AcademicYear.this.courses
    @subjects = []; @exams = []
    @exam_types = ExaminationType.find(:all)
    @exam = Examination.new(params[:examination])
    if request.post? and @exam.save
      flash[:notice] = "Examination has been saved."
      redirect_to :controller => "exam", :action => "create"
    end
  end

  def create_examtype
    @exam_types = ExaminationType.find(:all)
    @exam_type = ExaminationType.new(params[:examination_type])
    if request.post? and @exam_type.save
      flash[:notice] = "Examination type has been saved."
      redirect_to :action => "create_examtype"
    end
  end

  def create_grading
    @grading = Grading.new(params[:grading])
    return unless request.xhr? and @grading.save
    @grades = Grading.find(:all, :order => 'min_score DESC')
  end

  def delete
    exam = Examination.find(params[:id])
    course = exam.subject.course
    if exam.examination_results.empty?
      Examination.destroy(params[:id])
      @exams = course.examinations
      flash[:notice]="Exam was deleted successfully"
      redirect_to :action=>"create"
    else
      @exams = course.examinations
      flash[:notice]="Exam was not deleted because it is being used in examination results section!"
      redirect_to :action=>"create"
    end
  end

  def delete_examtype
    ExaminationType.destroy(params[:id])
    @exam_types = ExaminationType.find(:all)
    render :partial => "examtypes_list"
  end

  def delete_grading
    Grading.destroy(params[:id])
    @grades = Grading.find(:all, :order => 'min_score DESC')
  end

  def edit
    @examination = Examination.find(params[:id])
    @exam_types = ExaminationType.find(:all)
    @courses = AcademicYear.this.courses
    @course = @examination.subject.course
    @subjects = @course.subjects_with_exams
    @exams = @course.examinations
    if request.post? and @examination.update_attributes(params[:examination])
      flash[:notice] = "Exam has been saved."
      redirect_to :controller => "exam", :action => "index"
    end
  end

  def edit_examtype
    @examination_type = ExaminationType.find(params[:id])
    if request.post? and @examination_type.update_attributes(params[:examination_type])
      flash[:notice] = "Examination type has been updated."
      redirect_to :action => "create_examtype"
    end
  end

  def edit_grading
    @grades = Grading.find(:all, :order => 'min_score DESC')
    if request.post?
      params["grading"].each_pair { |g_id, min_scr| Grading.update(g_id, :min_score => min_scr["name"]) }
      redirect_to :controller => "exam", :action => "index"
    end
  end

  def grading_form_edit
    @grade = Grading.find(params[:id])
  end

  def index
    @current_user = current_user
  end

  def rename_grading
    return unless request.xhr?
    Grading.update(params[:grading][:id], params[:grading])
    @grades = Grading.find(:all, :order => 'min_score DESC')
  end

  def update_subjects_dropdown
    @subjects = []; @exams = []
    return if params[:course_id] == ''
    course = Course.find(params[:course_id])
    @subjects = course.subjects_with_exams
    @exams = course.examinations
  end

  def timetable
    @courses = AcademicYear.this.courses
    @examtypes = []
  end

  def update_examtypes
    subs = Subject.find_all_by_course_id(params[:course_id])
    exams = Examination.find_all_by_subject_id(subs, :select => "DISTINCT examination_type_id")
    etype_ids = exams.collect { |x| x.examination_type_id }
    @examtypes = ExaminationType.find(etype_ids)

    render :update do |page|
      page.replace_html "examtypes1", :partial => "examtypes", :object => @examtypes
    end
  end

  def load_timetable
    @course   = Course.find(params[:course_id])
    @examtype = ExaminationType.find(params[:examination_type_id])
    @subjects = Subject.find_all_by_course_id(@course.id, :conditions=>"no_exams = false")
    render :update do |page|
      page.replace_html 'exam_timetable', :partial => 'exam_timetable'
    end
  end
  
end
