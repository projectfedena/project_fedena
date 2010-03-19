class ReminderController < ApplicationController
before_filter :login_required
before_filter :protect_view_reminders, :only=>[:view_reminder,:mark_unread,:delete_reminder_by_recipient]
before_filter :protect_sent_reminders, :only=>[:view_sent_reminder,:delete_reminder_by_sender]
def index
    @user = current_user
    @unread_reminders = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false and is_deleted_by_recipient = false", :order=>"created_at DESC")
    @read_reminders = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = true and is_deleted_by_recipient = false", :order=>"created_at DESC")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false and is_deleted_by_recipient = false")
  end



  def create_reminder
    @user = current_user
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")
    if request.post?
      unless params[:reminder][:body] == "" or params[:recipients] == ""
        recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
        recipients_array.each do |r|
          user = User.find(r)
          Reminder.create(:sender=>@user.id, :recipient=>user.id, :subject=>params[:reminder][:subject],
            :body=>params[:reminder][:body], :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
        end
        flash[:notice] = "Reminder created..."
        redirect_to :controller=>"reminder", :action=>"create_reminder"
      else
        flash[:notice]="<b>ERROR:</b>Please fill the required fields to create this reminder"
        redirect_to :controller=>"reminder", :action=>"create_reminder"
      end
    end
  end

  def select_student_course
    @user = current_user
    @courses = AcademicYear.this.courses
    render :partial=>"select_student_course"
  end

  def to_students
    if params[:course_id] == ""
      render :update do |page|
        page.replace_html "to_users", :text => ""
      end
      return
    end

    course = Course.find(params[:course_id])
    #@to_students = course.students
    students = course.students
    @to_users = students.map { |s| s.user.id unless s.user.nil? }
    @to_users.delete nil
    render :update do |page|
      page.replace_html 'to_users', :partial => 'to_users', :object => @to_users
    end
  end

  def update_recipient_list
    recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
    @recipients = User.find(recipients_array)
    render :update do |page|
      page.replace_html 'recipient-list', :partial => 'recipient_list'
    end
  end

  def sent_reminder
    @user = current_user
    @sent_reminders = Reminder.find_all_by_sender(@user.id, :order=>"created_at DESC", :conditions=>"is_deleted_by_sender = false")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")
  end

  def view_sent_reminder
    @sent_reminder = Reminder.find(params[:id2])
  end

  def delete_reminder_by_sender
    user = current_user
    @sent_reminder = Reminder.find(params[:id2])
    Reminder.update(@sent_reminder.id, :is_deleted_by_sender => true)
    flash[:notice] = "Reminder deleted..."
    redirect_to :action =>"sent_reminder"
  end

  def delete_reminder_by_recipient
    user = current_user
    @reminder = Reminder.find(params[:id2])
    Reminder.update(@reminder.id, :is_deleted_by_recipient => true)
    flash[:notice] = "Reminder deleted..."
    redirect_to :action =>"index"
  end



  def view_reminder
    user = current_user
    @new_reminder = Reminder.find(params[:id2])
    Reminder.update(@new_reminder.id, :is_read => true)
    @sender = User.find(@new_reminder.sender)

    if request.post?
      unless params[:reminder][:body] == "" or params[:recipients] == ""
      Reminder.create(:sender=>user.id, :recipient=>@sender.id, :subject=>params[:reminder][:subject],
            :body=>params[:reminder][:body], :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
      flash[:notice]="Your reply has been sent"
      redirect_to :controller=>"reminder", :action=>"view_reminder", :id2=>params[:id2]
      else
        flash[:notice]="<b>ERROR:</b>Please enter both subject and body"
        redirect_to :controller=>"reminder", :action=>"view_reminder",:id2=>params[:id2]
      end
    end
  end

  def mark_unread
    @reminder = Reminder.find(params[:id2])
    Reminder.update(@reminder.id, :is_read => false)
    flash[:notice] = "Reminder marked unread..."
    redirect_to :controller=>"reminder", :action=>"index"
  end

end
