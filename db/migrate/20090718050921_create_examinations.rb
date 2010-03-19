class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.integer    :examination_type_id
      t.integer    :subject_id
      t.date       :date
      t.integer    :max_marks
      t.integer    :weightage
      t.timestamps
    end
  end

  def self.down
    drop_table :examinations
  end

end
