class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user && user.require_user(params[:password])
      login_user user
      redirect_to home_path, notice: 'You are logged in. Enjoy!'
    else
      flash[:error] = 'Your login credentials are invalid.'
      render :new
    end
  end

  def destroy
    logout_user
    redirect_to :root, notice: 'You are signed out.'
  end
end