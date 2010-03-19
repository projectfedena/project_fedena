class HolidayController < ApplicationController
  before_filter :login_required

  filter_access_to :all

  def index
    @holidays = Holiday.find(:all, :order => "start_date asc",
      :conditions => "start_date between '#{AcademicYear.this.start_date}' and '#{AcademicYear.this.end_date}'")
    @holiday = Holiday.new(params[:holiday])
    if request.post? and @holiday.save
      flash[:notice] = "Holiday saved"
      redirect_to :action => "index"
    end
  end

  def edit
    @holiday = Holiday.find(params[:id])
    if request.post? and @holiday.update_attributes(params[:holiday])
      flash[:notice] = "Holiday updated!"
      redirect_to :controller =>"holiday", :action => "index"
    end
  end

  def delete
    Holiday.find(params[:id]).destroy
    @holidays = Holiday.find(:all, :order => "start_date asc",
      :conditions => "start_date between '#{AcademicYear.this.start_date}' and '#{AcademicYear.this.end_date}'")
    render :partial => "list"
  end

end
