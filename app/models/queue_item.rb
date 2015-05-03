class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates_presence_of :user
  validates_presence_of :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def video_rating
    review = video.reviews.where(user: user).first
    return nil if review.nil?
    review.rating
  end

  def category_name
    category.name
  end
end