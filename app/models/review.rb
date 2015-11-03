class Review < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :user
  validates_presence_of :rating
  validates_presence_of :content
  validates_presence_of :video

  def self.rating_range
    (1..5)
  end
  validates_inclusion_of :rating, in: self.rating_range, allow_blank: true, message: 'must be between 1 and 5'

  delegate :title, to: :video, prefix: :video

  #validates :rating, inclusion: { in: self.rating_range, message: 'must be between 1 and 5' }
end