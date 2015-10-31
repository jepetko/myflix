class Admin::PaymentsController < AdminsController

  before_action :ensure_admin

  def index
    @payments = Payment.all
  end

end