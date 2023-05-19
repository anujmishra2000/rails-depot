class Admin::CategoriesController < ApplicationController
  before_action :is_admin?

  def index
    @categories = Category.all
  end

  def products
    @category_products = Category.find(params[:id]).products +  Category.find(params[:id]).sub_categories_products
  end
end
