class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates_presence_of :user
  validates_presence_of :video
  validates_numericality_of :order_value, {only_integer: true}

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def rating
    review = video.reviews.where(user: user).first
    return nil if review.nil?
    review.rating
  end

  def rating=(new_rating)
    if review
      if new_rating
        review.update_column :rating, new_rating
      else
        review.destroy!
      end
    else
      review = Review.new user: user, video: video, rating: new_rating
      review.save! validate: false
    end
  end

  def category_name
    category.name
  end

  def review
    @review ||= video.reviews.where(user: user).first
  end
end