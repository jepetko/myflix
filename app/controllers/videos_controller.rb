class VideosController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    @review = Review.new
    @queue_item = QueueItem.new
  end

  def search
    @videos = Video.search_by_title(params[:term])
  end
end