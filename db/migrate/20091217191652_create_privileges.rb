class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :name
      
      t.timestamps
    end
    Privilege.create :name => "ExaminationControl"
    Privilege.create :name => "EnterResults"
    Privilege.create :name => "ViewResults"
    Privilege.create :name => "Admission"
    Privilege.create :name => "StudentsControl"
    Privilege.create :name => "ManageNews"
    Privilege.create :name => "Timetable"
    Privilege.create :name => "AttendanceControl"
    Privilege.create :name => "AddNewClass"
    Privilege.create :name => "SubjectMaster"
    Privilege.create :name => "AcademicYear"
    Privilege.create :name => "HolidaySettings"
    Privilege.create :name => "GeneralSettings"
  end

  def self.down
    drop_table :privileges
  end
end
