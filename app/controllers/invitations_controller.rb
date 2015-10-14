class InvitationsController < ApplicationController

  before_action :require_user, only: [:new, :create]

  def new
    @invitation = Invitation.new(user: current_user)
  end

  def create
    @invitation = Invitation.find_by(user_id: current_user.id, email: invitation_params[:email])
    if !@invitation
      @invitation = Invitation.new invitation_params.merge(user_id: current_user.id)
    end
    @invitation.full_name = invitation_params[:full_name]
    if !@invitation.save
      flash[:danger] = 'Please, put valid values into the fields.'
      render :new and return
    end
    AppMailer.delay.send_mail_on_invite(@invitation.id, invitation_params[:message])
    flash[:success] = 'Your friend has been invited. Invite the next friend.'
    redirect_to new_invitation_path
  end

  def show
    invitation = Invitation.find_by(token: params[:token])
    if !invitation
      flash[:danger] = 'The invitation is expired. Please register and look for your friends on myflix.'
      redirect_to register_path
    else
      redirect_to register_path(token: params[:token])
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:full_name, :email, :message)
  end

end