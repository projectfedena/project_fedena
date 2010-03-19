class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :config_key
      t.string :config_value
    end
    create_default
  end

  def self.down
    drop_table :configurations
  end

  def self.create_default
    Configuration.create :config_key => "SchoolCollegeName", :config_value => ""
    Configuration.create :config_key => "StudentAttendanceType", :config_value => "Daily"
    Configuration.create :config_key => "AcademicYearID", :config_value => "1"
    Configuration.create :config_key => "CurrencyType", :config_value =>""
  end

end