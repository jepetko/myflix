PageMetrics::MetricsController.class_eval do

  include ApplicationController::AuthMethods

  before_action :ensure_admin

  def ensure_admin
    if !current_user.admin?
      flash[:danger] = 'You need to be an admin to do that'
      redirect_to main_app.home_path
    end
  end

end