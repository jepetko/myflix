class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :rating
  validates_presence_of :content
  validates_presence_of :video

  def self.rating_range
    (1..5)
  end

  validates :rating, inclusion: { in: self.rating_range, message: 'must be between 1 and 5' }
end