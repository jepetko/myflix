class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :link, LinkUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('lower(title) LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

  def calculate_rating_average
    return 0 if reviews.size == 0
    reviews.average(:rating).round(2).to_f
  end

  def large_cover_url
    large_cover.url || 'http://dummyimage.com/665x375/000000/00a2ff'
  end

  def small_cover_url
    small_cover.url || 'http://dummyimage.com/166x236/000000/00a2ff'
  end

  def link_url
    link.url
  end

  def link_url_ext
    File.extname(link_url).gsub('.', '') unless link_url.nil?
  end

end
