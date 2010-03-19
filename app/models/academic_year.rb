class AcademicYear < ActiveRecord::Base
  has_many :courses, :order => 'grade, section ASC'

  validates_presence_of :start_date
  validates_presence_of :end_date

  def validate
    errors.add(:start_date, 'cannot be less than end date') \
      if self.start_date > self.end_date \
        if self.start_date and self.end_date
  end

  def self.this
    this_year_id = Configuration.get('AcademicYearID')
    AcademicYear.find(this_year_id)
  end

end
