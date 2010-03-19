class Guardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :student

  attr_accessor :address1, :address2

  validates_presence_of :name, :relation

  def validate
    errors.add(:dob, "cannot be a future date.") if self.dob > Date.today \
      unless self.dob.nil?
  end

  def before_save
    self.office_address = [self.address1, "\n", self.address2].join
  end

  def is_immediate_contact?
    student = self.student
    student.immediate_contact_id == self.id
  end
  
end
