class CategoryController < ApplicationController
  def index
    @categories = Category.root.includes(:sub_categories)
end
