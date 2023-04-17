class ChangeDefaultValueOfEnabledInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :enabled, from:nil, to:false
  end
end
