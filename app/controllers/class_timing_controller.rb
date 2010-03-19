class ClassTimingController < ApplicationController
  before_filter :login_required
 
  
filter_access_to :all

  def index
    @period_timing=PeriodTiming.new(params[:class_timing])
    if request.post? and @period_timing.save
      flash[:notice]="Time for #{@period_timing.name} saved successfully"
      redirect_to :action=> "index"
    end
    @information=PeriodTiming.find(:all)
  end

  def edit
    @information=PeriodTiming.find(:all)
    @period_timing = PeriodTiming.find(params[:id])
    if request.post? and @period_timing.update_attributes(params[:class_timing])
      flash[:notice] = "Period Timing for #{@period_timing.name} updated!"
      redirect_to :controller =>"class_timing", :action => "index"
    end
  end

  def delete
    @period_timing = PeriodTiming.find(params[:id])
    @period_timing.destroy
    flash[:notice] = "Period Timing for #{@period_timing.name} deleted!"
    redirect_to :controller =>"class_timing", :action=>"index"
  end

 
end
