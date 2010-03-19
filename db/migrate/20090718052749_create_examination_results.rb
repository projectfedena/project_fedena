class CreateExaminationResults < ActiveRecord::Migration
  def self.up
    create_table :examination_results do |t|
      t.integer    :marks
      t.references :examination
      t.references :student
      t.references :grading
    end
  end

  def self.down
    drop_table :examination_results
  end
end
