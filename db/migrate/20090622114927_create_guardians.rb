class CreateGuardians < ActiveRecord::Migration
  def self.up
    create_table :guardians do |t|
      t.references :student
      t.string :name
      t.string :relation

      t.string :email
      t.string :office_phone1
      t.string :office_phone2
      t.string :mob_phone

      t.string :office_address
      t.string :city
      t.string :state
      t.references :country

      t.date :dob
      t.string :occupation
      t.string :income
      t.string :education

      t.timestamps
    end
  end

  def self.down
    drop_table :guardians
  end
end
