class CreateStudentsOldCoursesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :students_old_courses, :id => false do |t|
      t.references :student
      t.references :course
    end
  end

  def self.down
    drop_table :students_old_courses
  end
end
