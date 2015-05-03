class QueueItemsController < ApplicationController

  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def update

  end

  def create
    video = Video.find(params[:video_id])
    if ! current_user_queued_video? video
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