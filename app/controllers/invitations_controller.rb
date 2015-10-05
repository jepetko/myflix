class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new
    @invitation.user = current_user
  end

end