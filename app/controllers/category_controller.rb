class CategoryController < ApplicationController
  def index
    @categories = Category.includes(:sub_categories).where(parent_category_id: nil)
  end
end
