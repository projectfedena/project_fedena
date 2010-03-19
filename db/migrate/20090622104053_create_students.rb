class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|

      t.integer :admission_no
      t.integer :roll_no      # class roll no.
      t.date :admission_date

      t.string :first_name
      t.string :middle_name
      t.string :last_name

      t.integer :course_id
      t.date :date_of_birth
      t.boolean :gender
      t.string :blood_group
      t.string :birth_place
      t.integer :nationality_id
      t.string :language
      t.string :religion
      t.string :category

      t.string :address
      t.string :city
      t.string :state
      t.string :pin_code
      t.integer :country_id

      t.string :phone1
      t.string :phone2
      t.string :email

      t.string :photo_filename
      t.string :photo_content_type
      t.binary :photo_data, :limit => 5.megabytes

      t.string :status
      t.string :status_description

      t.integer :immediate_contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end

end
