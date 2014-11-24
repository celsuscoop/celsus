class Post < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  belongs_to :category
end
