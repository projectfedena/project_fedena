class Country < ActiveRecord::Base
  def all
    find :all, :order => name
  end
end
