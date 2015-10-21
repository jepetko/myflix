module ApplicationHelper

  def divide_in_chunks(arr, chunk_size)
    chunks = {}
    chunk_idx = 0
    arr.each_with_index do |item,idx|
      chunks[chunk_idx] ||= []
      chunks[chunk_idx] << item
      if (idx+1)%chunk_size == 0
        chunk_idx=chunk_idx+1
      end
    end
    chunks
  end

  def get_large_cover_url(video)
    video.large_cover.url || 'http://dummyimage.com/665x375/000000/00a2ff'
  end

  def get_small_cover_url(video)
    video.small_cover.url || 'http://dummyimage.com/166x236/000000/00a2ff'
  end

  def get_video_link_url(video)
    video.link.url
  end

  def get_video_link_url_ext(video)
    File.extname(video.link.url).gsub('.', '') unless video.link.url.nil?
  end

  def gravatar_url(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end

  def select_collection_rating_values
    Review.rating_range.to_a.reverse.map do |rating|
      [ pluralize(rating, 'star'), rating]
    end
  end

  def select_collection_category_values
    Category.all.map do |category|
      [ category.name, category.id ]
    end
  end
end
