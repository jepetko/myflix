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

    if @user.save

      begin
        Stripe::Charge.create(card: params[:stripeToken], amount: 999, description: "Myflix charge for #{@user.email}", currency: 'usd') if Stripe.api_key
      rescue Stripe::CardError => e
        flash.now[:danger] = e.message
        render :new
      end

      if params[:token]
        invitation = Invitation.find_by(token: params[:token])
        if invitation
          @user.follow invitation.user
          invitation.destroy
        end
      end

      AppMailer.delay.send_mail_on_register(@user.id)
      redirect_to sign_in_path
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
end