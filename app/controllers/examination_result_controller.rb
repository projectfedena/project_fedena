class ExaminationResultController < ApplicationController
  before_filter :login_required

  filter_access_to :all

  def add
    @courses = AcademicYear.this.courses
    @course1 = @courses[0] unless @courses.nil?
    @subjects = []
    @exams = []
  end

  def add_results
    @e_id = params[:examination_result][:examination_id]
    @c_id = Examination.find(@e_id).subject.course
    @students = Student.find_all_by_course_id(@c_id)
  end

  def save
    @exam_id = params[:exam_id]
    @results = params["examination_result"]
    @exam = Examination.find(@exam_id)
    @results.each_pair do |s_id, m|
      unless ( (r = ExaminationResult.find_by_examination_id_and_student_id(@exam_id, s_id)) == nil )
        unless m["marks"] == ""
          marks = m["marks"]
          percentage = marks.to_i * 100 / @exam.max_marks
          g_id = Grading.find(:first, :conditions => "min_score <= #{percentage.round}", :order => "min_score desc").id
        end
        ExaminationResult.update(r.id, { :marks => marks, :grading_id => g_id, :student_id => s_id, :examination_id => @exam_id } )
      else
        r1 = ExaminationResult.new
        unless m["marks"] == ""
          r1.marks = m["marks"]
          percentage = r1.marks.to_i * 100 / @exam.max_marks
          r1.grading_id = Grading.find(:first, :conditions => "min_score <= #{percentage.round}", :order => "min_score desc").id
        end
        r1.student_id = s_id
        r1.examination_id = @exam_id
        r1.save
      end
    end
    redirect_to :controller => "examination_result", :action => "add"
  end

  def update_subjects
    course = Course.find(params[:course_id]) unless params[:course_id] == ''
    if course
      @subjects = Subject.find_all_by_course_id(course.id)
    else
      @subjects = []
    end
    @exams = []
    render :update do |page|
      page.replace_html 'subjects1', :partial => 'subjects', :object => @subjects
      page.replace_html 'exams1', :partial => 'exams', :object => @exams
    end
  end
  def update_one_subject
    course = Course.find(params[:course_id]) unless params[:course_id] == ''
    if course
      @subjects = Subject.find_all_by_course_id(course.id)
    else
      @subjects = []
    end
    @exams = []
    render :update do |page|
      page.replace_html 'subjects1', :partial => 'one_sub', :object => @subjects
      page.replace_html 'exams1', :partial => 'one_sub_exams', :object => @exams
    end
  end

  def update_exams
    subject = Subject.find(params[:subject_id]) unless params[:subject_id] == ''
    if subject
      @exams = subject.examinations
    else
      @exams=[]
    end
    render :update do |page|
      page.replace_html 'exams1', :partial => 'exams', :object => @exams
    end
  end

  def update_one_sub_exams
    subject = Subject.find(params[:subject_id]) unless params[:subject_id] == ''
    if subject
      @exams = subject.examinations
    else
      @exams=[]
    end
    render :update do |page|
      page.replace_html 'exams1', :partial => 'one_sub_exams', :object => @exams
    end
  end

  def load_results

    @exm = Examination.find(params[:examination_id])
    @students = @exm.subject.course.students.active

    render :update do |page|
      page.replace_html 'exam_result', :partial => 'exam_result'
    end
  end

  def load_one_sub_result
    @exm = Examination.find(params[:examination_id])
    @students = @exm.subject.course.students.active
    render :update do |page|
      page.replace_html 'exam_result', :partial => 'one_sub_exam_result'
    end

  end

  def load_all_sub_result

    @course   = Course.find(params[:course_id])
    @examtype = ExaminationType.find(params[:examination_type_id])
    @subjects = @course.subjects
    @students = Student.find_all_by_course_id(@course.id,:conditions=>"status = 'Active'")
    @exams    = Examination.find_all_by_examination_type_id_and_subject_id(@examtype.id, @subjects.collect{|x| x})
    @res      = ExaminationResult.find_all_by_examination_id(@exams)
    render :update do |page|
      page.replace_html 'exam_result', :partial => 'all_sub_exam_result'
    end

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

  def view_all_subs
    @courses = AcademicYear.this.courses
    @examtypes = []
#    @course   = Course.find(params[:examination_result][:course_id])
#    @examtype = ExaminationType.find(params[:examination_result][:examtype_id])
#    @subjects = @course.subjects
#    @students = Student.find_all_by_course_id(@course.id)
#    @exams    = Examination.find_all_by_examination_type_id_and_subject_id(@examtype.id, @subjects.collect{|x| x})
#    @res      = ExaminationResult.find_all_by_examination_id(@exams)

#    if request.post?
#      if params[:examination_result][:examtype_id] == ""
#        flash[:notice] = "Please select an examination type"
#        redirect_to :action => "view_all_subs"
#        return
#      end
#
#      case params[:commit]
#      when "View"
#
#      when "Generate PDF Report"
#        course   = params[:examination_result][:course_id]
#        examtype = params[:examination_result][:examtype_id]
#        subjects = Subject.find_all_by_course_id(course)
#        students = Student.find_all_by_course_id(course, :order => "first_name ASC")
#        exams    = Examination.find_all_by_examination_type_id_and_subject_id(examtype, subjects)
#        res      = ExaminationResult.find_all_by_examination_id(exams)
#
#        _p = PDF::Writer.new
#        _p.text(ExaminationType.find(examtype).name, :font_size => 20, :justification => :center)
#        this_course = Course.find(course)
#        unless this_course.nil?
#          _p.text("Class : " + this_course.grade + " - " + this_course.section, :font_size => 14, :justification => :center)
#        end
#        _p.text(" ", :font_size => 20, :justification => :center)
#        PDF::SimpleTable.new do |t|
#          t.column_order.push("Name")
#          subjects.each {|s| t.column_order.push(s.name)}
#          students.each do |st|
#            x = {"Name"  => st.first_name + " " + st.last_name}
#            subjects.each do |sub|
#              exam = Examination.find_by_subject_id_and_examination_type_id(sub.id, examtype)
#              unless exam.nil?
#                examres = ExaminationResult.find_by_examination_id_and_student_id(exam.id, st.id)
#                x[sub.name] = examres.marks unless examres.nil?
#              end
#            end
#            t.data << x
#          end
#          t.render_on(_p) unless res.nil?
#        end
#        send_data _p.render, :filename => "report.pdf", :type => "application/pdf", :disposition => 'inline'
#      end
#    end
  end




  def view_one_sub
    @courses = AcademicYear.this.courses
    @subjects = []
    @exams = []
  end

  # pdf-generation

  def one_sub_pdf
    @institute_name = Configuration.find_by_config_key("SchoolCollegeName")
    @exm = Examination.find(params[:id])
    @students = @exm.subject.course.students
    @i = 0
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def all_sub_pdf
    @institute_name = Configuration.find_by_config_key("SchoolCollegeName")
    @course   = Course.find(params[:id])
    @examtype = ExaminationType.find(params[:id2])
    @subjects = @course.subjects
    @students = Student.find_all_by_course_id(@course.id)
    @exams    = Examination.find_all_by_examination_type_id_and_subject_id(@examtype.id, @subjects.collect{|x| x})
    @res      = ExaminationResult.find_all_by_examination_id(@exams)
    @i = 1

    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

end