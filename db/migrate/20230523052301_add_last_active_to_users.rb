class AddLastActiveToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_active, :datetime
  end
end
