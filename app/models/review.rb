class Review < ActiveRecord::Base
  belongs_to :video
  validates_presence_of :rating
  validates_presence_of :comment

  validate :rating_between_0_and_5

  private

  def rating_between_0_and_5
    if !rating.nil? && !rating.between?(0, 5)
      errors.add(:rating, 'must be between 0 and 5')
    end
  end
end