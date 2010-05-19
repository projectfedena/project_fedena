class UserController < ApplicationController
  layout :choose_layout
  
  before_filter :login_required, :except => [:forgot_password, :login, :set_new_password, :reset_password]
  before_filter :only_admin_allowed, :only => [:edit, :create, :index,:edit_privilege]

  #filter_access_to :all

  def choose_layout
    return 'login' if action_name == 'login' or action_name == 'set_new_password'
    return 'forgotpw' if action_name == 'forgot_password'
    'application'
  end
  
  def all
    @users = User.find :all
  end
  def list_user
    if params[:user_type] == 'Admin'
      @users = User.find(:all, :conditions => {:admin => true}, :order => 'first_name ASC')
      render(:update) do |page|
        page.replace_html 'users', :partial=> 'users'
        page.replace_html 'student_user', :text => ''
      end
    elsif params[:user_type] == 'Student'
      render(:update) do |page|
        page.replace_html 'student_user', :partial=> 'student_user'
        page.replace_html 'users', :text => ''
      end
    end
  end

  def list_student_user
    course = params[:course_id]
    @student = Student.find_all_by_course_id(course, :conditions=>"status = 'Active'",:order =>'first_name ASC')
    @users = @student.collect { |student| student.user}
    @users.delete(nil)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end
  def change_password
    #flash[:notice]="You do not have permission to change demo account password!"
    #redirect_to :action=>"dashboard"
    
    if request.post?
     @user = current_user
    if User.authenticate?(@user.username, params[:user][:old_password])
     if params[:user][:new_password] == params[:user][:confirm_password]
      @user.password = params[:user][:new_password]
     @user.save
    flash[:notice] = 'Password changed successfully.'
    redirect_to :action => 'dashboard'
    else
     flash[:notice] = 'Password confirmation failed. Please try again.'
    end
     else
      flash[:notice] = 'The old password you entered is incorrect. Please enter valid password.'
     end
    end
  end

  def user_change_password
    user = User.find_by_username(params[:id])
    if request.post?
      if params[:user][:new_password] == params[:user][:confirm_password]
        user.password = params[:user][:new_password]
        flash[:notice]="Password changed successfully."
        redirect_to :action=>"edit", :id=>user.username
      else
        flash[:notice] = 'Password confirmation failed. Please try again.'
      end
      end
    end

  def create
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = 'User account created!'
      redirect_to :controller => 'user', :action => 'dashboard'
    else
    end
  end

  def delete
    @user = User.find_by_username(params[:id]).destroy
    flash[:notice] = 'User account deleted!'
    redirect_to :controller => 'user'
  end

  def dashboard
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
  end

  def edit
    @user = User.find_by_username(params[:id])
    if request.post? and @user.update_attributes(params[:user])
      flash[:notice] = 'User account updated!'
      redirect_to :controller => 'user', :action => 'profile', :id => @user.username
    end
  end

  def forgot_password
    flash[:notice]="You do not have permission to access forgot password!"
    redirect_to :action=>"login"
  
    if request.post? and params[:reset_password]
      if user = User.find_by_email(params[:reset_password][:email])
        user.reset_password_code = Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
        user.reset_password_code_until = 1.day.from_now
        user.save(false)
        UserNotifier.deliver_forgot_password(user)
        flash[:notice] = "Reset Password link emailed to #{user.email}"
        redirect_to :action => "index"
      else
        flash[:notice] = "No user exists with email address #{params[:reset_password][:email]}"
      end
    end
  end

  def login
    if request.post? and params[:user]
      @user = User.new(params[:user])
      user = User.find_by_username @user.username
      if user and User.authenticate?(@user.username, @user.password)
        session[:user_id] = user.id
        flash[:notice] = "Welcome, #{user.first_name} #{user.last_name}!"
        redirect_to :controller => 'user', :action => 'dashboard'
      else
        flash[:notice] = 'Invalid username or password combination'
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to :controller => 'user', :action => 'login'
  end

  def profile
    @current_user = current_user
    @username = @current_user.username if session[:user_id]
    @user = User.find_by_username(params[:id])
    if @user.nil?
      flash[:notice] = 'User profile not found.'
      redirect_to :action => 'dashboard'
    end
  end

  def reset_password
    user = User.find_by_reset_password_code(params[:id])
    if user
      if user.reset_password_code_until > Time.now
        redirect_to :action => 'set_new_password', :id => user.reset_password_code
      else
        flash[:notice] = 'Reset time expired'
        redirect_to :action => 'index'
      end
    else
      flash[:notice]= 'Invalid reset link'
      redirect_to :action => 'index'
    end
  end

  def search_user_ajax
    @user = nil
    unless params[:query] == ''
      query = params[:query].to_s.gsub("\"", " ")
      @user = User.find(:all,
        :conditions => "(first_name LIKE \"#{query}%\"
                  OR last_name LIKE \"#{query}%\"
                  OR username LIKE \"#{query}%\"
                  OR (concat(first_name, \" \", last_name) LIKE \"#{query}%\"))")
    end
    render :layout => false
  end

  def set_new_password
    if request.post?
      user = User.find_by_reset_password_code(params[:id])
      if user
        if params[:set_new_password][:new_password] === params[:set_new_password][:confirm_password]
          User.update(user.id, :password => params[:set_new_password][:new_password],
            :reset_password_code => nil, :reset_password_code_until => nil)
          flash[:notice] = 'Password succesfully reset. Use new password to log in.'
          redirect_to :action => 'index'
        else
          flash[:notice] = 'Password confirmation failed. Please enter password again.'
          redirect_to :action => 'set_new_password', :id => user.reset_password_code
        end
      else
        flash[:notice] = 'You have followed an invalid link. Please try again.'
        redirect_to :action => 'index'
      end
    end
  end

  def edit_privilege
    @privileges = Privilege.find(:all)
    @user = User.find_by_username(params[:id])
    if request.post?
      new_privileges = params[:user][:privilege_ids] if params[:user]
      new_privileges ||= []
      @user.privileges = Privilege.find_all_by_id(new_privileges)

      flash[:notice] = 'Role updated.'
      redirect_to :action => 'profile',:id => @user.username
    end
    
  end
  
end
