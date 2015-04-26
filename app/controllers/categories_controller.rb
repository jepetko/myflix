class CategoriesController < ApplicationController

  before_action :authenticate

  def show
    @category = Category.find(params[:id])
  end

end