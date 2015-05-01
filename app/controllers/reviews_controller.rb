class ReviewsController < ApplicationController

  before_action :require_user

  def create
    review = Review.new review_params
    review.video_id = params[:video_id]
    review.user = current_user
    if review.save
      flash[:notice] = 'Review posted successfully.'
    else
      flash[:error] = 'Review not saved.'
    end
    redirect_to video_path review.video
  end

  private

  def review_params
    params.require(:review).permit :content, :rating
  end

end