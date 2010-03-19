class Holiday < ActiveRecord::Base
  validates_presence_of :name, :start_date, :end_date

  def validate
    if self.start_date and self.end_date
      if self.start_date > self.end_date
        errors.add(:start_date, 'cannot come after end date')
      end
    end
  end

  def self.contains_day?(day)
    return true if Holiday.count(:all, :conditions =>["start_date <=? AND end_date>=?", day, day ]) > 0
    false
  end
end
