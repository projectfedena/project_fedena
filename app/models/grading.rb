class Grading < ActiveRecord::Base
  has_many :examination_results

  def self.find_from_percentage(percentage)
    return nil unless percentage
    find(:first, :conditions => "min_score <= #{percentage}", :order => 'min_score DESC')
  end
end
