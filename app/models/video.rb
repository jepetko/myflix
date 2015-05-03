class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('lower(title) LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

  def calculate_rating_average
    return 0 if reviews.size == 0
    reviews.average(:rating).round(2).to_f
  end

  def rating_for_user(user)
    review = reviews.where(user: user).first
    return nil if review.nil?
    review.rating
  end
end
