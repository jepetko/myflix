class HomeController < ApplicationController

  def home
    @categories = Category.all
  end
end