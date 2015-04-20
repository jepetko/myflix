class Video < ActiveRecord::Base
  belongs_to :category
  default_scope ->{ order('title') }
  validates :title, presence: true
  validates :description, presence: true
end
