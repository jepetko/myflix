class RelationshipsController < ApplicationController

  before_filter :require_user

  def create
    user = User.find(params[:id])
    current_user.follow user
    flash[:message] = "By now, you are following the user #{user.full_name}."
    redirect_to user_path(current_user)
  end

  def index
    @followed_users = current_user.followed_users
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow user
    flash[:message] = "By now, you are not following the user #{user.full_name} anymore."
    redirect_to user_path(current_user)
  end
end
