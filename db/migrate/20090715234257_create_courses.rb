class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :grade
      t.string :section
      t.string :code
      t.references :academic_year
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end

end
