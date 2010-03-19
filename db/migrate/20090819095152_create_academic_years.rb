class CreateAcademicYears < ActiveRecord::Migration
  def self.up
    create_table :academic_years do |t|
      t.date :start_date
      t.date :end_date
      t.integer :previous_year
      t.timestamps
    end
    create_default
  end

  def self.down
    drop_table :academic_years
  end

  def self.create_default
    AcademicYear.create(:id => 1, :start_date => Date.today, :end_date => Date.today + 365.days)
  end
end
