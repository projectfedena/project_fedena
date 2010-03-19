class StudentController < ApplicationController
  before_filter :login_required
 # before_filter :protect_student_profile, :except => [:subject_wise_report, :graph_for_one_subject]
 before_filter :protect_other_student_data

  filter_access_to :all

  def academic_report
    @user = current_user
    @student = Student.find(params[:id])
    @course = @student.old_courses.find_by_academic_year_id(params[:year]) if params[:year]
    @course ||= @student.course
    @subjects = Subject.find_all_by_course_id(@course, :conditions => "no_exams = false")
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )

    @student = Student.find(params[:id]) if params[:id]
    @student ||= @course.students.first
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @arr_total_wt = {}
    @arr_score_wt = {}
    @subjects.each do |s|
      @arr_total_wt[s.name] = 0
      @arr_score_wt[s.name] = 0
    end
    @course.examinations.each do |x|
      @arr_total_wt[x.subject.name] += x.weightage
      ex_score = ExaminationResult.find_by_examination_id_and_student_id(x.id, @student.id)
      @arr_score_wt[x.subject.name] += ex_score.marks * x.weightage / x.max_marks unless ex_score.nil?
    end
  end

  def change_to_former
    @student = Student.find(params[:id])
    if request.post? and !params[:remove][:description].nil?
      @student.update_attributes(:status => "Former", :status_description => params[:remove][:description])
      flash[:notice] = "#{@student.full_name} (admission no #{@student.admission_no}) has left the school."
      redirect_to :controller => 'user', :action => 'dashboard'
    end
  end

  def delete
    @student = Student.find(params[:id])
  end

  def destroy
    student = Student.find(params[:id])
    Attendance.destroy_all(:student_id => student.id)
    ExaminationResult.destroy_all(:student_id => student.id)
    User.destroy_all(:username => student.id)
    Student.destroy(params[:id])
    flash[:notice] = "All records have been deleted for student with admission no. #{student.admission_no}."
    redirect_to :controller => 'user', :action => 'dashboard'
  end

  def email
    @student = Student.find(params[:id])
    sender = current_user.email
    if request.post?
      recipient_list = []
      case params['email']['recipients']
      when 'Student'
        recipient_list << @student.email
      when 'Guardian'
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      when 'Student & guardian'
        recipient_list << @student.email
        recipient_list << @student.immediate_contact.email unless @student.immediate_contact.nil?
      end
      recipients = recipient_list.join(', ')
      FedenaMailer::deliver_email(sender,recipients, params['email']['subject'], params['email']['message'])
      flash[:notice] = "Mail sent to #{recipients}"
      redirect_to :controller => 'student', :action => 'profile', :id => @student.id
    end
  end

  def exam_report
    @user = current_user
    @examtype = ExaminationType.find(params[:exam])
    @course = Course.find(params[:course])
    @student = Student.find(params[:student]) if params[:student]
    @student ||= @course.students.first
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350,
      "/student/graph_for_exam_report?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
  end

  def update_student_result_for_examtype
    @student = Student.find(params[:student])
    @examtype = ExaminationType.find(params[:examtype])
    @course = @student.course
    @prev_student = @student.previous_student
    @next_student = @student.next_student
    @subjects = @course.subjects_with_exams
    @results = {}
    @subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, @examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, @student)
      @results[s.id.to_s] = { 'subject' => s, 'result' => res } unless res.nil?
    end
    @graph = open_flash_chart_object(770, 350,
      "/exam/graph_for_student_exam_result?course=#{@course.id}&examtype=#{@examtype.id}&student=#{@student.id}")
    render(:update) { |page| page.replace_html 'exam-results', :partial => 'student_result_for_examtype' }
  end

  def previous_years_marks_overview
    @student = Student.find(params[:student])
    @all_courses = @student.all_courses
    @graph = open_flash_chart_object(770, 350,
      "/student/graph_for_previous_years_marks_overview?student=#{params[:student]}&graphtype=#{params[:graphtype]}")
  end

  def remove
    @student = Student.find(params[:id])
  end

  def reports
    @student = Student.find(params[:id])
    @subjects = @student.subjects_with_exams
    @examtypes = @student.examination_types
    @old_courses = @student.all_courses
  end

  def search_ajax
    if params[:option] == "active"
      status_cond = "status = \"Active\""
    elsif params[:option] == "former"
      status_cond = "status = \"Former\""
    else
      status_cond = "true"
    end
    query = params[:query]
    query = query.gsub("\"", ' ')
    @students = Student.find(:all,
      :conditions => "(first_name LIKE \"#{query}%\"
                       OR middle_name LIKE \"#{query}%\"
                       OR last_name LIKE \"#{query}%\"
                       OR (concat(first_name, \" \", last_name) LIKE \"#{query}%\"))
                       AND #{status_cond}",
      :order => "first_name asc") unless query == ''
    render :layout => false
  end

  def student_annual_overview
    @graph = open_flash_chart_object(770, 350,
      "/student/graph_for_student_annual_overview?student=#{params[:student]}&year=#{params[:year]}")
  end

  def subject_wise_report
    @student = Student.find(params[:student])
    @subject = Subject.find(params[:subject])
    @examtypes = @subject.examination_types
    @graph = open_flash_chart_object(770, 350,
      "/student/graph_for_subject_wise_report_for_one_subject?student=#{params[:student]}&subject=#{params[:subject]}")
  end

  # Graphs

  def graph_for_previous_years_marks_overview
    student = Student.find(params[:student])

    x_labels = []
    data = []

    student.all_courses.each do |c|
      x_labels << c.name
      data << student.annual_weighted_marks(c.academic_year_id)
    end

    if params[:graphtype] == 'Line'
      line = Line.new
    else
      line = BarFilled.new
    end

    line.width = 1; line.colour = '#5E4725'; line.dot_size = 5; line.values = data

    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Academic year")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Total marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def graph_for_student_annual_overview
    student = Student.find(params[:student])
    course = Course.find_by_academic_year_id(params[:year]) if params[:year]
    course ||= student.course
    subs = course.subjects
    exams = Examination.find_all_by_subject_id(subs, :select => "DISTINCT examination_type_id")
    etype_ids = exams.collect { |x| x.examination_type_id }
    examtypes = ExaminationType.find(etype_ids)
    
    x_labels = []
    data = []

    examtypes.each do |et|
      x_labels << et.name
      data << student.examtype_average_marks(et, course)
    end

    x_axis = XAxis.new
    x_axis.labels = x_labels

    line = BarFilled.new

    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data

    y = YAxis.new
    y.set_range(0,100,20)

    title = Title.new('Title')

    x_legend = XLegend.new("Examination name")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Average marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def graph_for_subject_wise_report_for_one_subject
    student = Student.find params[:student]
    subject = Subject.find params[:subject]
    exams = Examination.find_all_by_subject_id(subject.id, :order => 'date asc')

    data = []
    x_labels = []

    exams.each do |e|
      exam_result = ExaminationResult.find_by_examination_id_and_student_id(e, student.id)
      unless exam_result.nil?
        data << exam_result.percentage_marks
        x_labels << XAxisLabel.new(exam_result.examination.examination_type.name, '#000000', 10, 0)
      end
    end

    x_axis = XAxis.new
    x_axis.labels = x_labels
    
    line = BarFilled.new
    
    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data

    y = YAxis.new
    y.set_range(0,100,20)

    title = Title.new(subject.name)

    x_legend = XLegend.new("Examination name")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
    chart.x_axis = x_axis

    chart.add_element(line)

    render :text => chart.to_s
  end

  def graph_for_exam_report
    student = Student.find(params[:student])
    examtype = ExaminationType.find(params[:examtype])
    course = student.course
    subjects = course.subjects_with_exams

    x_labels = []
    data = []
    data2 = []

    subjects.each do |s|
      exam = Examination.find_by_subject_id_and_examination_type_id(s, examtype)
      res = ExaminationResult.find_by_examination_id_and_student_id(exam, student)
      unless res.nil?
        x_labels << s.name
        data << res.percentage_marks
        data2 << exam.average_marks * 100 / exam.max_marks
      end
    end

    bargraph = BarFilled.new()
    bargraph.width = 1;
    bargraph.colour = '#bb0000';
    bargraph.dot_size = 5;
    bargraph.text = "Student's marks"
    bargraph.values = data

    bargraph2 = BarFilled.new
    bargraph2.width = 1;
    bargraph2.colour = '#5E4725';
    bargraph2.dot_size = 5;
    bargraph2.text = "Class average"
    bargraph2.values = data2


    x_axis = XAxis.new
    x_axis.labels = x_labels

    y_axis = YAxis.new
    y_axis.set_range(0,100,20)

    title = Title.new(student.full_name)

    x_legend = XLegend.new("Academic year")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Total marks")
    y_legend.set_style('{font-size: 14px; color: #770077}')

    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.y_axis = y_axis
    chart.x_axis = x_axis
    chart.y_legend = y_legend
    chart.x_legend = x_legend

    chart.add_element(bargraph)
    chart.add_element(bargraph2)

    render :text => chart.render
  end


  def admission1
    @countries = Country.all
    @nationalities = Country.all
    @courses = AcademicYear.this.courses

    @adm_no_value = Student.next_admission_no
    @student = Student.new(params[:master_student])
    @student.address = params[:address1].to_s + "\n" + params[:address2].to_s
    @student.status = "Active"
    if request.post? and @student.save
      if params[:master_student][:gender] == "true"
        Student.update(@student.id, :gender => true)
      else
        Student.update(@student.id, :gender => false)
      end

        @user = User.new
        @user.first_name = @student.first_name
        @user.last_name = @student.last_name
        @user.username = @student.admission_no.to_s
        @user.password = @student.admission_no.to_s + "123"
        @user.role = 'Student'

        if @student.email == "" or User.find_by_email(@student.email)
          @user.email = "noreply" + @student.admission_no.to_s + "@fedena.com"
        else
          @user.email = @student.email
        end
        @user.save

      flash[:notice] = "Student record saved."
      redirect_to :controller => "student", :action => "admission2", :id => @student.id
    end
  end

  def admission2
    @student  = Student.find(params[:id])
    @parent_info = Guardian.new(params[:parent_detail])
    @countries = Country.all
    @parent_info.office_address = params[:address1].to_s + "\n" + params[:address2].to_s

    case params[:commit]
    when "Skip"
      flash[:notice] ="Skipped"
      redirect_to :controller => "user" ,:action => "dashboard"
    when "Finish"
      redirect_to :controller => "student" ,:action => "admission3", :id => @student.id \
        if request.post? and @parent_info.save
    when "Add more"
      redirect_to :controller => "student", :action => "admission2", :id => @student.id \
        if request.post? and @parent_info.save
    end
  end

  def admission3
    @student = Student.find(params[:id])
    @parents = @student.guardians
    return if params[:immediate_contact].nil?
    if request.post?
      Student.update(@student.id, :immediate_contact_id => params[:immediate_contact][:contact])
      flash[:notice] = "Student records saved for #{@student.first_name} #{@student.last_name}."
      redirect_to :controller => "student", :action => "profile", :id => @student.id
    end
  end

  def add_guardian
    @student  = Student.find(params[:id])
    @parent_info = Guardian.new(params[:parent_detail])
    @parent_info.office_address = params[:address1].to_s + "\n" + params[:address2].to_s
    @countries = Country.all
    case params[:commit]
    when "Skip"
      flash[:notice] ="Skipped"
      redirect_to :controller => "student", :action => "profile", :id => @student.id
    when "Finish"
      if request.post? and @parent_info.save
        flash[:notice] = "Parent details saved for #{@student.first_name}"
        redirect_to :controller => "student", :action => "admission3", :id => @student.id
      end
    when "Add more"
      if request.post? and @parent_info.save
        flash[:notice] = "Parent details saved for #{@parent_info.student_id}"
        redirect_to :controller => "student" , :action => "admission2", :id => @student.id
      end
    end
  end

  def list_students_by_course
    @students = Student.find_all_by_course_id(params[:course_id], :conditions=>"status = 'Active'",:order => 'first_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'students_by_course' }
  end

  def profile
    @student = Student.find(params[:id])
    @current_user = current_user
    @address = @student.address.to_s.gsub("\n", ", ")
    @immediate_contact = Guardian.find(@student.immediate_contact_id) \
      unless @student.immediate_contact_id.nil? or @student.immediate_contact_id == ''
  end
  
  def show
    @student = Student.find_by_admission_no(params[:id])
    send_data(@student.photo_data,
      :type => @student.photo_content_type,
      :filename => @student.photo_filename,
      :disposition => 'inline')
  end

  def view_all
    @courses = AcademicYear.this.courses
  end

  def edit
    @student = Student.find(params[:id])
    @address = @student.address.split("\n")
    @countries = Country.all
    @nationalities = Country.all
    @courses = AcademicYear.this.courses
    @m = false; @m = true if @student.gender == true
    @student.address = params[:address1].to_s + "\n" + params[:address2].to_s
    if request.post? and @student.update_attributes(params[:student])
      flash[:notice] = "Student Record updated!"
      redirect_to :controller => "student", :action => "profile", :id => @student.id
    end
  end

  def edit_guardian
    @parent = Guardian.find(params[:id])
    @address = @parent.office_address.split("\n")
    @student = Student.find(@parent.student_id)
    @parent.office_address = params[:address1].to_s + "\n" + params[:address2].to_s
    @countries = Country.all
    if request.post? and @parent.update_attributes(params[:parent_detail])
      flash[:notice] = "Parent Record updated!"
      redirect_to :controller => "student", :action => "guardians", :id => @student.id
    end
  end

  def guardians
    @student = Student.find(params[:id])
    @parents = Guardian.find_all_by_student_id(@student.id)
    @current_user = current_user
  end

  def del_guardian
    @guardian = Guardian.find(params[:id])
    @student = @guardian.student
    if @guardian.is_immediate_contact?
      if @guardian.destroy
        flash[:notice] = "Guardian has been deleted"
        redirect_to :controller => 'student', :action => 'admission3', :id => @student.id
      end
    else
      if @guardian.destroy
        flash[:notice] = "Guardian has been deleted"
        redirect_to :controller => 'student', :action => 'profile', :id => @student.id
      end
    end
  end

  def academic_pdf
    @student = Student.find(params[:id])
    @course = @student.old_courses.find_by_academic_year_id(params[:year]) if params[:year]
    @course ||= @student.course
    @subjects = Subject.find_all_by_course_id(@course, :conditions => "no_exams = false")
    @examtypes = ExaminationType.find( ( @course.examinations.collect { |x| x.examination_type_id } ).uniq )

    @arr_total_wt = {}
    @arr_score_wt = {}
    @subjects.each do |s|
      @arr_total_wt[s.name] = 0
      @arr_score_wt[s.name] = 0
    end
    @course.examinations.each do |x|
      @arr_total_wt[x.subject.name] += x.weightage
      ex_score = ExaminationResult.find_by_examination_id_and_student_id(x.id, @student.id)
      @arr_score_wt[x.subject.name] += ex_score.marks * x.weightage / x.max_marks unless ex_score.nil?
    end

    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end
  
end