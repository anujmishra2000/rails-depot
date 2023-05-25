class AddLanguagePreferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :language, :string, default: "English"
  end
end
