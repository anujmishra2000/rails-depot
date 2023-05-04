class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.belongs_to :parent_category, foreign_key: { to_table: :categories }
      t.timestamps
    end
  end
end
