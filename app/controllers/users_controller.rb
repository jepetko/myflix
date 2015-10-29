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
    sign_up = SignUpService.new(@user).sign_up(stripeToken: params[:stripeToken], token: params[:token])
    if sign_up.successful?
      flash[:success] = sign_up.message
      redirect_to sign_in_path
    else
      flash.now[:danger] = sign_up.message
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

end