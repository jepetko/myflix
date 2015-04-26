class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def login_user(user)
    session[:email] = user.email
  end

  def logout_user
    session[:email] = nil
  end

  def logged_in?
    !current_user.blank?
  end

  def current_user
    @current_user ||= User.find_by(email: session[:email])
  end

  def authenticate
    if !logged_in?
      flash[:error] = 'You are not allowed to access this page. Please, log in.'
      redirect_to :root
    end
  end

end
