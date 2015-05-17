class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def update
    queue_items = queue_items_params_from_json
    QueueItem.transaction do
      begin
        current_queue_items = current_user.queue_items.all
        ids = current_queue_items.map(&:id)
        updateable_queue_items = queue_items.select { |item| ids.include?(item[:id].to_i) }.sort do |a,b|
          first_order_value = a[:order_value].to_i
          sec_order_value = b[:order_value].to_i
          raise ArgumentError.new('order value must not be alphanumerical or zero') if first_order_value == 0 || sec_order_value == 0
          a[:order_value].to_i-b[:order_value].to_i
        end
        order_value = updateable_queue_items.first[:order_value].to_i

        updateable_queue_items.each do |updateable_queue_item|
          current_queue_item = current_queue_items.find(updateable_queue_item[:id].to_i)
          current_queue_item.order_value = order_value
          order_value += 1
          current_queue_item.save
        end
      rescue Exception => e
        flash[:error] = 'Queue items order not updated'
      end
    end
    redirect_to my_queue_path
  end

  def create
    video = Video.find(params[:video_id])
    if !current_user_queued_video? video
      if video_queued?(video)
        flash[:notice] = "Video #{video.title} was added to the queue."
      else
        flash[:error] = 'Video not added.'
      end
    else
      flash[:notice] = 'Video already in the queue.'
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = current_user.queue_items.find_by(id: params[:id])
    if queue_item && queue_item.destroy
      current_user.queue_items.each_with_index do |item,idx|
        item.update(order_value: idx+1)
      end
      flash[:notice] = "Video #{queue_item.video_title} removed from the queue."
    else
      flash[:error] = 'Video not removed.'
    end
    redirect_to my_queue_path
  end

  private

  def queue_items_params_from_json
    JSON.parse(params.require(:queue_items)).each { |element| element.symbolize_keys! }
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video_id).include? video.id
  end

  def new_position
    current_user.queue_items.count + 1
  end

  def video_queued?(video)
    queue_item = current_user.queue_items.build video_id: video.id, order_value: new_position
    queue_item.save
  end

end