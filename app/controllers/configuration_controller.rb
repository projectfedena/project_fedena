class ConfigurationController < ApplicationController
  before_filter :login_required
  
  filter_access_to :all

  def index
  end
  
  def settings
    @school_college_name = Configuration.find_by_config_key("SchoolCollegeName")
    @student_attendance_type = Configuration.find_by_config_key("StudentAttendanceType")
    @currency_type = Configuration.find_by_config_key("CurrencyType")
    if request.post?
      Configuration.update(@school_college_name.id,
        :config_value => params[:configuration][:school_college_name])
      Configuration.update(@student_attendance_type.id,
        :config_value => params[:configuration][:student_attendance_type])
      Configuration.update(@currency_type.id,
        :config_value => params[:configuration][:currency_type])
      unless params[:upload].nil?
        post = Configuration.save(params[:upload])
      end
      flash[:notice]="Settings has been saved"
      redirect_to :action => "settings"
    end
  end

  def permissions
    # TODO: Decide how to do this.
  end

end