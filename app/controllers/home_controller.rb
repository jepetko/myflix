class HomeController < ApplicationController

  def home
    @categories = Category.all
  end

  def front
  end
end