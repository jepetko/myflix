class ReviewsController < ApplicationController

  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = Review.new review_params.merge!(video_id: params[:video_id], user: current_user)
    if review.save
      flash[:notice] = 'Review posted successfully.'
      redirect_to @video
    else
      flash[:error] = 'Review not saved.'
      @reviews = @video.reviews
      @review = Review.new
      render template: 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit :content, :rating
  end

end