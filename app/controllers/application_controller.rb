class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :require_user

  helper_method :logged_in?, :current_user

  module AuthMethods

    def login_user(user)
      session[:user_id] = user.id
    end

    def logout_user
      session[:user_id] = nil
    end

    def logged_in?
      !current_user.blank?
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if !session[:user_id].nil?
    end

    def require_user
      if !logged_in?
        flash[:error] = 'You are not allowed to access this page. Please, log in.'
        redirect_to sign_in_path
      end
    end

  end

  include AuthMethods
end
