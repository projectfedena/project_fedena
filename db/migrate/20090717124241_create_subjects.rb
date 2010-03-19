class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :name
      t.string :code
      t.integer :course_id
      t.boolean :no_exams         # Indicates that the subject has no exams associated.
      t.integer :max_hours_week
      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end

end
