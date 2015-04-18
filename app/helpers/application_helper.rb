module ApplicationHelper

  def divide_in_chunks(model, size)
    chunks = {}
    chunk_idx = 0
    model.each_with_index do |item,idx|
      chunks[chunk_idx] ||= []
      chunks[chunk_idx] << item
      if (idx+1)%size == 0
        chunk_idx=chunk_idx+1
      end
    end
    chunks
  end

end
