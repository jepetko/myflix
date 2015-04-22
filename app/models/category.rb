class Category < ActiveRecord::Base
  has_many :videos, -> { order('title')}

  def recent_videos
    Video.where(category: self).order('created_at desc').limit(6)
  end
end