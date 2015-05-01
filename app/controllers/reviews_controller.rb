class ReviewsController < ApplicationController

  before_action :require_user

  def create
    review = Review.new review_params
    if review.save
      flash[:notice] = 'Review posted successfully.'
      redirect_to video_path review.video
    else
      flash[:error] = 'Review not saved.'
      render 'videos/show', video: review.video
    end
  end

  private

  def review_params
    params.require(:review).permit :content, :rating, :video_id, :user_id
  end

end