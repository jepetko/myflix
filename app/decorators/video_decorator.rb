class VideoDecorator < Draper::Decorator
  delegate_all

  def total_rating
    return "#{average_rating} / 5.0" if reviews.any?
    'N/A'
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