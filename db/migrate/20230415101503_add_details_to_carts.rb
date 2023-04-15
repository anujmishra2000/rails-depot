class AddDetailsToCarts < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :line_items_count, :integer
    change_column_default :carts, :line_items_count, from:nil, to:0
    change_column_null :carts, :line_items_count, false
  end
end
