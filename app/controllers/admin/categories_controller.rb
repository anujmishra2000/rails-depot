class Admin::CategoriesController < ApplicationController
  def index
    if current_user.admin?
      @categories = Category.all
    else
      redirect_to store_index_path, notice: "You don't have privilege to access this section"
    end
  end
end
