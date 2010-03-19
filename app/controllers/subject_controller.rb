class SubjectController < ApplicationController
  before_filter :login_required
#  before_filter :only_admin_allowed

  filter_access_to :all

  def create
    @courses = AcademicYear.this.courses
    if request.post?
      @subject = Subject.new(params[:subject])
      if @subject.save
        flash[:notice] = 'New subject created'
        redirect_to :controller => "subject", :action => "create"
      end
    end
  end

  def delete
    subject = Subject.find(params[:id])
    if subject.attendances.empty? and subject.examinations.empty? and subject.timetable_entries.empty?
      Subject.destroy(params[:id])
      @subjects = Subject.find(:all)
      flash[:notice]="Subject deleted successfully"
      redirect_to :controller=>"subject", :action=>"index"
    else
      @subjects = Subject.find(:all)
      flash[:notice]="Subject was not deleted because it may be used elsewhere!."
      redirect_to :controller=>"subject", :action=>"index"
    end
  end
  
  def edit
    @courses = AcademicYear.this.courses
    @subject = Subject.find(params[:id])
    if request.post? and @subject.update_attributes(params[:subject])
      flash[:notice] = "Subject updated!"
      redirect_to :controller =>"subject", :action => "index"
    end
  end

  def index
    @courses = AcademicYear.this.courses
  end

  def list_subjects
    @subjects = Subject.find_all_by_course_id(params[:course_id])
    render :partial => "subjects_list"
  end

end
