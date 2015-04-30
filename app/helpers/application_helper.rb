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

  def get_img_url(video)
    "/tmp/#{video.img}" || 'http://dummyimage.com/665x375/000000/00a2ff'
  end

  def select_collection_rating_values
    rating_values = []
    Review.rating_range.each do |rating|
      rating_values << [ pluralize(rating, 'star'), rating]
    end
    rating_values
  end
end
