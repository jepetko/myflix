class QueuedVideosController < ApplicationController

  before_action :require_user

  def my_queue
    @queued_videos = current_user.queued_videos
  end

  def update_my_queue

  end

end