class VideosController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @review = Review.new
    @queue_item = QueueItem.new
  end

  def search
    @videos = Video.search_by_title(params[:term])
  end

  def advanced_search
    query = params[:query]
    @videos = query ? Video.search(query, advanced_search_options).records.to_a.map(&:decorate) : []
  end

  private

  def advanced_search_options
    params.permit :reviews, :rating_from, :rating_to
  end

end