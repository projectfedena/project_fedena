class News < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_many :comments, :class_name => 'NewsComment'
  validates_presence_of :title, :content
end
