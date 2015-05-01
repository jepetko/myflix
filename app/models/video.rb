class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('lower(title) LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

  def calculate_rating_average
    ratings = reviews.map(&:rating)
    return 0 if ratings.blank?
    (ratings.inject(:+).to_f / ratings.count.to_f).round 2
  end
end
