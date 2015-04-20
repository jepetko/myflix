class Video < ActiveRecord::Base
  belongs_to :category
  default_scope ->{ order('title') }

  validates_presence_of :title, :description
end
