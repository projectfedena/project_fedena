# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091217201118) do

  create_table "academic_years", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "previous_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.date    "attendance_date"
    t.integer "student_id"
    t.integer "subject_id"
  end

  create_table "configurations", :force => true do |t|
    t.string "config_key"
    t.string "config_value"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "courses", :force => true do |t|
    t.string   "grade"
    t.string   "section"
    t.string   "code"
    t.integer  "academic_year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examination_results", :force => true do |t|
    t.integer "marks"
    t.integer "examination_id"
    t.integer "student_id"
    t.integer "grading_id"
  end

  create_table "examination_types", :force => true do |t|
    t.string   "name"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examinations", :force => true do |t|
    t.integer  "examination_type_id"
    t.integer  "subject_id"
    t.date     "date"
    t.integer  "max_marks"
    t.integer  "weightage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gradings", :force => true do |t|
    t.string   "name"
    t.integer  "min_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guardians", :force => true do |t|
    t.integer  "student_id"
    t.string   "name"
    t.string   "relation"
    t.string   "email"
    t.string   "office_phone1"
    t.string   "office_phone2"
    t.string   "mob_phone"
    t.string   "office_address"
    t.string   "city"
    t.string   "state"
    t.integer  "country_id"
    t.date     "dob"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_comments", :force => true do |t|
    t.text     "content"
    t.integer  "news_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "period_timings", :force => true do |t|
    t.string  "name"
    t.time    "start_time"
    t.time    "end_time"
    t.boolean "break"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "privilege_id"
  end

  create_table "reminders", :force => true do |t|
    t.integer  "sender"
    t.integer  "recipient"
    t.string   "subject"
    t.string   "message"
    t.boolean  "is_read"
    t.boolean  "is_deleted_by_sender"
    t.boolean  "is_deleted_by_recipient"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restricted_page_permissions", :id => false, :force => true do |t|
    t.integer "restricted_page_id"
    t.integer "user_id"
  end

  create_table "restricted_pages", :force => true do |t|
    t.string "controller"
    t.string "action"
  end

  create_table "students", :force => true do |t|
    t.integer  "admission_no"
    t.integer  "roll_no"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "course_id"
    t.date     "date_of_birth"
    t.boolean  "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "nationality_id"
    t.string   "language"
    t.string   "religion"
    t.string   "category"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "pin_code"
    t.integer  "country_id"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "photo_filename"
    t.string   "photo_content_type"
    t.binary   "photo_data",           :limit => 16777215
    t.string   "status"
    t.string   "status_description"
    t.integer  "immediate_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students_old_courses", :id => false, :force => true do |t|
    t.integer "student_id"
    t.integer "course_id"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "course_id"
    t.boolean  "no_exams"
    t.integer  "max_hours_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetable_entries", :force => true do |t|
    t.integer "course_id"
    t.integer "timetable_week_day_id"
    t.integer "period_timing_id"
    t.integer "subject_id"
    t.integer "employee_id"
  end

  create_table "timetable_week_days", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "student"
    t.boolean  "employee"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
