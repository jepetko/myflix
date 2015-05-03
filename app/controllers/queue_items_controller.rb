class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def update

  end

  def create
    count = current_user.queue_items.size
    queue_item = current_user.queue_items.build queue_item_params.merge(order_value: count)

    if queue_item.save
      flash[:notice] = "Video #{queue_item.video_title} was added to the queue."
      redirect_to my_queue_path
    else
    end
  end

  private

  def queue_item_params
    params.require(:queue_item).permit(:video_id)
  end
end