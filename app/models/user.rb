class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queue_items, -> { order('order_value') }

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

  def update_queue_items(queue_items_hash)
    ActiveRecord::Base.transaction do
      ids = queue_items.all.map(&:id)
      updateable_queue_items = sort_updateable_queue_items queue_items_hash, ids
      start_order_value = 1

      updateable_queue_items.each do |updateable_queue_item|
        current_queue_item = queue_items.find(updateable_queue_item[:id].to_i)
        current_queue_item.update_attributes! order_value: start_order_value
        start_order_value += 1
      end
    end
  end

  private

  def sort_updateable_queue_items(queue_items, ids)
    queue_items.select { |item| ids.include?(item['id'].to_i) }.sort do |a,b|
      first_order_value = a['order_value'].to_i
      sec_order_value = b['order_value'].to_i
      raise ArgumentError.new('order value must not be alphanumerical or zero') if first_order_value == 0 || sec_order_value == 0
      a['order_value'].to_i-b['order_value'].to_i
    end
  end

end