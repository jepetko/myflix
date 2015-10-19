class AdminsController < ApplicationController
  before_action :ensure_admin

  private

  def ensure_admin
    if not current_user.admin?
      flash[:danger] = 'You need to be an admin to do that'
      redirect_to home_path
    end
  end
end