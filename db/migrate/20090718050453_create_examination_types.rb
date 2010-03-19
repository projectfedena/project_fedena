class CreateExaminationTypes < ActiveRecord::Migration
  def self.up
    create_table :examination_types do |t|
      t.string   :name
      t.boolean  :primary
      t.timestamps
    end
  end

  def self.down
    drop_table :examination_types
  end
end
