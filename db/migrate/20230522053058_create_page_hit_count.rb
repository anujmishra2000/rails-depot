class CreatePageHitCount < ActiveRecord::Migration[7.0]
  def change
    create_table :page_hit_counts do |t|
      t.string :path, null: false
      t.integer :hit_count, default: 0

      t.timestamps
    end
  end
end
