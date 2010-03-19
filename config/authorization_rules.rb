authorization do

  #custom - privileges
  
  role :examination_control do
    has_permission_on [:exam], :to => [:index,:create_examtype,:create,:create_grading,:delete,:delete_examtype,
                                           :delete_grading,:edit,:edit_examtype,:edit_grading,:grading_form_edit,:rename_grading,
                                           :update_subjects_dropdown]
  end

  role :enter_results  do
    has_permission_on [:exam],                 :to => [:index]
    has_permission_on [:examination_result], :to => [:add,:load_results,:add_results,:save,:update_subjects,:update_one_subject,
                                                            :update_exams,:update_one_sub_exams]
  end

  role :view_results  do
    has_permission_on [:exam],                 :to => [:index]
    has_permission_on [:examination_result], :to => [:load_results,:load_one_sub_result,:load_all_sub_result,:update_examtypes,
                                                            :update_subjects,:update_one_subject,:update_exams,:update_one_sub_exams,
                                                            :one_sub_pdf,:all_sub_pdf,:view_all_subs,:view_one_sub]
  end

  role :admission do
    has_permission_on [:student], :to => [:profile,:admission1,:admission2,:admission3,:add_guardian,:edit,:edit_guardian,
                                               :guardians,:del_guardian,:list_students_by_course,:show,:view_all]
  end

  role :students_control do
    has_permission_on [:student] , :to => [:academic_reports_pdf,:profile,:guardians,:list_students_by_course,:show,:view_all,
                                                :index,:academic_report,:change_to_former,:delete,:destroy,:email,:exam_report,
                                                :update_student_result_for_examtype,:previous_years_marks_overview,:remove,:reports,
                                                :search_ajax,:student_annual_overview,:subject_wise_report,
                                                :graph_for_previous_years_marks_overview,:graph_for_student_annual_overview,
                                                :graph_for_subject_wise_report_for_one_subject,:graph_for_exam_report]
  end

  role :manage_news do
    has_permission_on [:news], :to => [:index,:add,:add_comment,:all,:delete,:delete_comment,:edit,:search_news_ajax,:view]
  end

  role :timetable_edit do
    has_permission_on [:timetable],    :to => [:index,:edit,:delete_subject,:select_class,:tt_entry_update,:tt_entry_noupdate,
                                                 :update_multiple_timetable_entries,:update_timetable_view]
    has_permission_on [:class_timing], :to => [:index,:edit,:delete]
  end

  role :timetable_view do
    has_permission_on [:timetable], :to => [:index,:select_class,:view]
  end

  role :student_attendance_view do
    has_permission_on [:attendance], :to => [:index,:report,:student_report]
  end

  role :student_attendance_register do
    has_permission_on [:attendance], :to => [:index,:register,:register_attendance]
  end

  role :add_new_class do
    has_permission_on [:configuration], :to => [:index]
    has_permission_on [:course],         :to => [:create,:delete,:edit,:email,:upcoming_exams,:view]
  end

  role :subject_master do
    has_permission_on [:configuration], :to => [:index]
    has_permission_on [:subject],        :to => [:index,:create,:delete,:edit,:list_subjects]
  end

  role :academic_year do
    has_permission_on [:configuration], :to => [:index]
    has_permission_on [:academic_year], :to => [:index,:add_course,:migrate_classes,:migrate_students,:list_students,
                                                      :update_courses,:upcoming_exams]
  end

  role :holiday_settings do
    has_permission_on [:configuration], :to => [:index]
    has_permission_on [:holiday],        :to => [:index,:edit,:delete]
  end

  role :general_settings do
    has_permission_on [:configuration], :to => [:index,:settings,:permissions]
  end

  role :finance_control do
    has_permission_on [:finance], :to => [:index,:automatic_transactions,:categories,:donation,:donation_receipt,:expense_create,
                                               :expense_edit,:fee_collection,:fee_submission,:fees_received,:fee_structure,
                                               :fees_student_specific,:income_create,:income_edit,:transactions,:category_create,
                                               :category_delete,:category_edit,:category_update,:get_child_fee_element_form,
                                               :get_new_fee_element_form,:create_child_fee_element,:create_new_fee_element,
                                               :reset_fee_element,:fee_collection_create,:fee_collection_delete,
                                               :fee_collection_edit,:fee_collection_update,:fee_structure_create,:fee_structure_delete,
                                               :fee_structure_edit,:fee_structure_update,:transaction_trigger_create,
                                               :fees_student_search]
  end

  role :hr_basics do
    has_permission_on [:employee], :to => [:index,:add_category,:edit_category,:delete_category,:add_position,:edit_position,
                                                :delete_position,:add_department,:edit_department,:delete_department,:add_grade,
                                                :edit_grade,:delete_grade,:admission1,:update_positions,:edit1,:edit_personal,
                                                :admission2,:edit2,:edit_contact,:admission3,:edit3,:admission3_1,:edit3_1,:admission4,
                                                :change_reporting_manager,:reporting_manager_search,:update_reporting_manager_name,
                                                :edit4,:search,:search_ajax,:select_reporting_manager,:profile,:profile_general,
                                                :profile_personal,:profile_address,:profile_contact,:profile_bank_details,
                                                :profile_payroll_details,:view_all,:show,:subject_assignment,:update_subjects,
                                                :select_department,:update_employees,:assign_employee,:remove_employee,
                                                :hr,:select_department_employee,:settings,:employee_management,:add_bank_details,
                                                :edit_bank_details,:add_additional_details,:edit_additional_details]
    has_permission_on [:payroll] , :to => [:add_category,:edit_category,:manage_payroll,:activate_category,:inactivate_category]
  end
  
  role :employee_attendance do
    has_permission_on [:employee],             :to => [:hr,:employee_attendance,:leave_management]
    has_permission_on [:employee_attendance], :to => [:add_leave_types,:register,:report,:leave_management,:edit_leave_types,
                                                             :update_attendance_form,:update_attendance_report,
                                                             :individual_leave_application,:all_employee_new_leave_application,
                                                             :all_employee_leave_application,:update_employees_select,:leave_list,
                                                             :leave_app,:emp_attendance,:employee_attendance_pdf]
  end
  
  role :payslip_powers do
    has_permission_on [:employee], :to => [:hr,:payslip,:select_department_employee,:update_employee_select_list,
                                                :payslip_date_select,:one_click_payslip_generation,:payslip_revert_date_select,
                                                :one_click_payslip_revert,:ceate_monthly_select_list,:add_payslip_category,
                                                :create_payslip_category,:remove_new_paylist_category,:delete_payslip,:view_payslip,
                                                :update_monthly_payslip,:invidual_payslip_pdf,:create_monthly_payslip]
    has_permission_on [:payroll], :to=>[:edit_payroll_details,:activate_category,:inactivate_category]
  end
  
  role :employee_search do
    has_permission_on [:employee], :to => [:search,:view_all,:search_ajax,:profile]
  end

  role :employee_timetable_access do
    has_permission_on [:employee], :to => [:timetable]
  end

  # admin privileges
  role :admin do
    has_permission_on [:academic_year],       :to => [:index,:add_course,:migrate_classes,:migrate_students,:list_students,
                                                      :update_courses,:upcoming_exams]
    has_permission_on [:attendance],           :to => [:index,:register,:register_attendance,:report,:student_report]
    has_permission_on [:class_timing],         :to => [:index,:edit,:delete]
    has_permission_on [:configuration],        :to => [:index,:settings,:permissions]
    has_permission_on [:course],                :to => [:create,:delete,:edit,:email,:upcoming_exams,:view]
    has_permission_on [:employee_attendance], :to => [:index,:add_leave_types,:edit_leave_types,:register,
                                                             :update_attendance_form,:report,:update_attendance_report,:emp_attendance,
                                                             :leaves,:leave_application,:leave_app,:approve_remarks,:deny_remarks,
                                                             :approve_leave,:deny_leave,:cancel,:new_leave_applications,
                                                             :all_employee_new_leave_applications,:all_leave_applications,
                                                             :individual_leave_applications,:own_leave_application,:cancel_application,
                                                             :update_all_application_view]
    has_permission_on [:exam],                 :to => [:index,:create_examtype,:create,:create_grading,:delete,:delete_examtype,
                                                           :delete_grading,:edit,:edit_examtype,:edit_grading,:grading_form_edit,
                                                           :rename_grading,:update_subjects_dropdown,:timetable,:update_examtypes,
                                                           :load_timetable]
    has_permission_on [:examination_result], :to => [:add,:add_results,:save,:update_subjects,:update_one_subject,:update_exams,
                                                            :update_one_sub_exams,:load_results,:load_one_sub_result,
                                                            :load_all_sub_result,:update_examtypes,:one_sub_pdf,:all_sub_pdf,
                                                            :view_all_subs,:view_one_sub]
    has_permission_on [:finance], :to => [:index,:automatic_transactions,:categories,:donation,:donation_receipt,:expense_create,
                                               :expense_edit,:fee_collection,:fee_submission,:fees_received,:fee_structure,
                                               :fees_student_specific,:income_create,:income_edit,:transactions,:category_create,
                                               :category_delete,:category_edit,:category_update,:get_child_fee_element_form,
                                               :get_new_fee_element_form,:create_child_fee_element,:create_new_fee_element,
                                               :reset_fee_element,:fee_collection_create,:fee_collection_delete,:fee_collection_edit,
                                               :fee_collection_update,:fee_structure_create,:fee_structure_delete,:fee_structure_edit,
                                               :fee_structure_update,:transaction_trigger_create,:fees_student_search]
    has_permission_on [:holiday],  :to => [:index,:edit,:delete]
    has_permission_on [:news],     :to => [:index,:add,:add_comment,:all,:delete,:delete_comment,:edit,:search_news_ajax,:view]
    has_permission_on [:payroll] , :to => [:index,:add_category,:edit_category,:activate_category,:inactivate_category,
                                                :manage_payroll,:update_dependent_fields,:edit_payroll_details]
    has_permission_on [:student] , :to => [:academic_pdf,:profile,:admission1,:admission2,:admission3,:add_guardian,:edit,
                                                :edit_guardian,:guardians,:del_guardian,:list_students_by_course,:show,:view_all,
                                                :index,:academic_report,:change_to_former,:delete,:destroy,:email,:exam_report,
                                                :update_student_result_for_examtype,:previous_years_marks_overview,:remove,
                                                :reports,:search_ajax,:student_annual_overview,:subject_wise_report,
                                                :graph_for_previous_years_marks_overview,:graph_for_student_annual_overview,
                                                :graph_for_subject_wise_report_for_one_subject,:graph_for_exam_report]
    has_permission_on [:subject],   :to => [:index,:create,:delete,:edit,:list_subjects]
    has_permission_on [:timetable], :to => [:index,:edit,:delete_subject,:select_class,:tt_entry_update,:tt_entry_noupdate,
                                                 :update_multiple_timetable_entries,:view,:update_timetable_view,:tt_entry_noupdate2,
                                                 :select_class2,:edit2,:update_employees,:update_multiple_timetable_entries2,
                                                 :delete_employee2,:tt_entry_update2]
    has_permission_on [:employee], :to => [:index,:add_category,:edit_category,:delete_category,:add_position,:edit_position,
                                                :delete_position,:add_department,:edit_department,:delete_department,:add_grade,
                                                :edit_grade,:delete_grade,:admission1,:update_positions,:edit1,:edit_personal,
                                                :admission2,:edit2,:edit_contact,:admission3,:edit3,:admission4,
                                                :change_reporting_manager,:reporting_manager_search,:update_reporting_manager_name,
                                                :edit4,:search,:search_ajax,:select_reporting_manager,:profile,:profile_general,
                                                :profile_personal,:profile_address,:profile_contact,:profile_bank_details,
                                                :profile_payroll_details,:view_all,:show,:add_payslip_category,:create_payslip_category,
                                                :remove_new_paylist_category,:create_monthly_payslip,:view_payslip,:update_monthly_payslip,
                                                :delete_payslip,:view_attendance,:subject_assignment,:update_subjects,:select_department,
                                                :update_employees,:assign_employee,:remove_employee,:hr,:payslip,:select_department_employee,
                                                :update_employee_select_list,:payslip_date_select,:one_click_payslip_generation,
                                                :payslip_revert_date_select,:one_click_payslip_revert,:leave_management,:all_employee_leave_applications,
                                                :update_employees_select,:leave_list,:reminder,:create_reminder,:to_employees,:update_recipient_list,
                                                :sent_reminder,:view_sent_reminder,:delete_reminder,:view_reminder,:mark_unread,:pull_reminder_form,
                                                :send_reminder,:individual_payslip_pdf,:settings,:employee_management,:employee_attendance,:employees_list,
                                                :add_bank_details,:edit_bank_details,:admission3,:admission3_1,:add_additional_details,:edit_additional_details,
                                                :profile_additional_details,:edit3_1]
  end

  # student- privileges
  role :student do
    has_permission_on [:course], :to => [:view]
    has_permission_on [:examination_result], :to => [:load_results,:load_one_sub_result,:one_sub_pdf,:view_one_sub]
    has_permission_on [:student] , :to => [:exam_report,:academic_pdf,:profile,:guardians,:list_students_by_course,
                                                :show,:academic_report,:previous_years_marks_overview,:reports,
                                                :student_annual_overview,:subject_wise_report,:graph_for_previous_years_marks_overview,
                                                :graph_for_student_annual_overview,:graph_for_subject_wise_report_for_one_subject,
                                                :graph_for_exam_report]
    has_permission_on [:news],        :to => [:index,:all,:search_news_ajax,:view,:add_comment]
    has_permission_on [:subject],     :to => [:index,:list_subjects]
    has_permission_on [:timetable],  :to => [:student_view,:update_timetable_view]
    has_permission_on [:attendance], :to => [:student_report]
  end

  # employee -privileges
  role :employee do
    has_permission_on [:employee],:to => [:profile,:profile_general,:profile_personal,:profile_address,:profile_contact,
                                               :profile_bank_details,:profile_payroll_details,:profile_additional_details,:reminder,
                                               :sent_reminder,:create_reminder,:to_employees,:view_sent_reminder,:update_recipient_list,
                                               :delete_reminder_by_sender,:delete_reminder_by_recipient,:view_reminder,:mark_unread,
                                               :view_payslip,:view_attendance,:timetable,:update_monthly_payslip,:create_reminder_1,
                                               :select_employee_department,:create_reminder_form,:select_student_course,:to_students,
                                               :all_employee_leave_applications,:individual_payslip_pdf]
    has_permission_on [:news], :to => [:index,:all,:search_news_ajax,:view,:add_comment]
    has_permission_on [:employee_attendance], :to => [:index,:leaves,:leave_application,:own_leave_application,
                                                             :cancel_application,:individual_leave_applications,:all_leave_applications,
                                                             :update_all_application_view,:new_leave_applications,:approve_remarks,
                                                             :deny_remarks,:cancel, :all_employee_new_leave_applications]
    has_permission_on [:reminder], :to =>[:reminder,:create_reminder,:select_employee_department,:select_student_course,
                                               :to_employees,:to_students,:update_recipient_list,:sent_reminder,:view_sent_reminder,
                                               :delete_reminder_by_sender,:delete_reminder_by_recipient,:view_reminder,:mark_unread]
  end
end