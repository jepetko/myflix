class ReviewsController < ApplicationController

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build review_params.merge!(user: current_user)
    if review.save
      flash[:notice] = 'Review posted successfully.'
      redirect_to @video
    else
      flash[:error] = 'Review not saved.'
      @reviews = @video.reviews.reload
      @review = Review.new
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit :content, :rating
  end

end