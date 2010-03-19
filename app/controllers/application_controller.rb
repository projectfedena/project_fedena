class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery # :secret => '434571160a81b5595319c859d32060c1'
  filter_parameter_logging :password
  
  before_filter { |c| Authorization.current_user = c.current_user }

  def initialize
    @title = 'Fedena'
  end

  def current_user
    User.find(session[:user_id]) unless session[:user_id].nil?
  end

  def permission_denied
    flash[:notice] = "Sorry, you are not allowed to access that page."
    redirect_to :controller => 'user', :action => 'dashboard'
  end
  
  
  protected

  def login_required
    redirect_to '/' unless session[:user_id]
  end

  def only_admin_allowed
    redirect_to :controller => 'user', :action => 'dashboard' unless current_user.admin?
  end

  def protect_other_student_data
    if current_user.student?
      unless params[:id] == current_user.username or params[:student] == current_user.username
        flash[:notice] = 'You are not allowed to view that information.'
        redirect_to :controller=>"user", :action=>"dashboard"
      end
    end
  end


  #reminder filters
  def protect_view_reminders
    reminder = Reminder.find(params[:id2])
    unless reminder.recipient == current_user.id
      flash[:notice] = 'You are not allowed to view that information.'
      redirect_to :controller=>"reminder", :action=>"index"
    end
  end

  def protect_sent_reminders
    reminder = Reminder.find(params[:id2])
    unless reminder.sender == current_user.id
      flash[:notice] = 'You are not allowed to view that information.'
      redirect_to :controller=>"reminder", :action=>"index"
    end
  end
end