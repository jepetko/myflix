class UsersController < ApplicationController

  skip_before_action :require_user, only: [:new, :create]

  def new
    @user = User.new
    if params[:token]
      invitation = Invitation.find_by(token: params[:token])
      @token = invitation.token
      @user.email = invitation.email
      @user.full_name = invitation.full_name
    end
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      response = StripeWrapper::Charge.create(card: params[:stripeToken], description: "Myflix charge for #{@user.email}")
      if response.successful?
        @user.save
        AppMailer.delay.send_mail_on_register(@user.id)
        flash.now[:success] = 'You have been charged successfully. An email has been sent to your email. Enjoy Myflix!'
        accept_invitation
        redirect_to sign_in_path
      else
        flash.now[:danger] = response.error_message
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :full_name
  end

  def accept_invitation
    return if !params[:token]
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user.follow invitation.user
      invitation.destroy
    end
  end
end