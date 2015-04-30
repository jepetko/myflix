class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :rating
  validates_presence_of :content

  validate :rating_in_range

  def self.rating_range
    (1..5)
  end

  private

  def rating_in_range
    if !rating.nil? && !rating.between?(Review.rating_range.min, Review.rating_range.max)
      errors.add(:rating, 'must be between 1 and 5')
    end
  end

end