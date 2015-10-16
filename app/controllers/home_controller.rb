class HomeController < ApplicationController

  before_action :require_user

  def home
    @categories = Category.all
    1/0
  end

end