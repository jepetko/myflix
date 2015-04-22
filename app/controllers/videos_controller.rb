class VideosController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    term = params[:term]
    if term.blank?
      @videos = []
      flash[:notice] = 'No search term given.'
    else
      @videos = Video.search_by_title term
    end
    respond_to do|format|
      format.html
    end
  end
end