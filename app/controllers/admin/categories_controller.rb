class Admin::CategoriesController < AdminBaseController
  def index
    @categories = Category.all
  end
end
