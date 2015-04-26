class HomeController < ApplicationController

  before_action :require_user

  def home
    @categories = Category.all
  end

end