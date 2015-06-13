class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queue_items, -> { order('order_value') }
  has_many :reviews

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes! order_value: index+1
    end
  end

  def video_in_queue?(video)
    queue_items.where(video: video).length > 0
  end
end