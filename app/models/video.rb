class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(title)
    Video.where("lower(title) LIKE '%#{title}%'")
  end
end
