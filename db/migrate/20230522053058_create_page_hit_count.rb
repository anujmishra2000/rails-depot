class CreatePageHitCount < ActiveRecord::Migration[7.0]
  def change
    create_table :page_hit_counts do |t|
      t.string :path
      t.integer :hit_count

      t.timestamps
    end
  end
end
