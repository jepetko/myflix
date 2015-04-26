class HomeController < ApplicationController

  before_action :authenticate

  def home
    @categories = Category.all
  end

end