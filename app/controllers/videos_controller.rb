class VideosController < ApplicationController

  before_action :authenticate

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @videos = Video.search_by_title(params[:term])
  end
end