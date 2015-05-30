class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queue_items, -> { order('order_value') }
  has_many :reviews

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

  def update_queue_items(queue_items_hash)
    ActiveRecord::Base.transaction do
      queue_items_hash.each do |queue_item_element|
        queue_item = queue_items.find_by(id: queue_item_element['id'])
        next if queue_item.nil?
        update_order_value queue_item, queue_item_element['order_value']
        update_rating queue_item, queue_item_element['rating']
      end
      normalize_queue_items
    end
  end

  private

  def update_order_value(queue_item, order_value)
    order_value = order_value.to_i
    if order_value == 0
      raise ArgumentError.new 'invalid order_value'
    end
    queue_item.update_attributes! order_value: order_value if !queue_item.nil?
  end

  def update_rating(queue_item, rating)
    if !rating.nil?
      rating = rating.to_i
      video_reviews = reviews.where(video: queue_item.video)
      if video_reviews.first
        video_reviews.first.update_attributes! rating: rating
      else
        reviews.build rating: rating, video: queue_item.video, content: 'Dummy'
        save!
      end
    end

  end

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes! order_value: index+1
    end
  end

end