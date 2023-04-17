class AddLineItemsCountColumnToCarts < ActiveRecord::Migration[7.0]
  def change
    change_table(:carts) do |t|
      t.integer :line_items_count, :height, null: false, default: 0
    end
  end
end
