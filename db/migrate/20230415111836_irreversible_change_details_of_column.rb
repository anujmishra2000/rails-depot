class IrreversibleChangeDetailsOfColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :permalink, :text
  end
end
