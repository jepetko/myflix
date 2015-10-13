class PasswordsController < ApplicationController

  def new
  end

  def create
    email = params[:email]
    user = User.find_by(email: email)
    if user
      user.reset_password_token = SecureRandom.urlsafe_base64
      user.save
      AppMailer.send_mail_on_reset_password(user)
      render 'passwords/confirm'
    end
  end

  def edit
    @token = params[:token]
    @user = User.find_by(reset_password_token: @token)
    if !@user
      flash[:danger] = 'Your reset password link is expired.'
    end
  end

  def update
    token = params[:token]
    password = params[:password]
    user = User.find_by(reset_password_token: token)
    if user
      user.password = password
      user.password_confirmation = password
      user.reset_password_token = nil
      user.save
      redirect_to sign_in_path
    else
      flash[:danger] = 'Your reset password link is expired'
      redirect_to reset_password_path(token)
    end
  end

end