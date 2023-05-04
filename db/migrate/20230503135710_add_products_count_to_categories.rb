class AddProductsCountToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :products_count, :integer, null: false, default: 0
  end
end
