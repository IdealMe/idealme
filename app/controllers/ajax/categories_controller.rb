class Ajax::CategoriesController < ApplicationController
  # GET /ajax/categories.json
  def index
    @categories = Category.all
  end

  # GET /ajax/categories/1.json
  def show
    @category = Category.find(params[:id])
  end
end
