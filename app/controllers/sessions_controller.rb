class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      login_user user
      redirect_to '/home'
    else
      flash[:error] = 'Your login credentials are invalid.'
      render :new
    end
  end

  def destroy
    if logged_in?
      logout_user
      redirect_to :root
    end
  end
end