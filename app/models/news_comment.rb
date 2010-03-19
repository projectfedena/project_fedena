class NewsComment < ActiveRecord::Base
  belongs_to :news
  belongs_to :author, :class_name => 'User'
end
