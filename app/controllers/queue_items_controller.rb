class QueueItemsController < ApplicationController

  def index
    @queue_items = current_user.queue_items
  end

  def update_queue
    queue_items_hash =  params[:queue_items]
    begin
      ActiveRecord::Base.transaction do
        queue_items_hash.each do |item|
          queue_item = current_user.queue_items.find_by(id: item['id'])
          queue_item.update! order_value: item[:order_value], rating: item[:rating] if queue_item
        end
        current_user.normalize_queue_items
      end
    rescue Exception => e
      flash[:error] = 'Queue items order not updated'
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