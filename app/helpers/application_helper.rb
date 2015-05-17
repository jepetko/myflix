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
    video.img ? "/tmp/#{video.img}" : 'http://dummyimage.com/665x375/000000/00a2ff'
  end

  def select_collection_rating_values
    Review.rating_range.to_a.reverse.map do |rating|
      [ pluralize(rating, 'star'), rating]
    end
  end

  def build_queue_items_json(queue_items)
    queue_items.to_json(only: [:id, :order_value])
  end
end
