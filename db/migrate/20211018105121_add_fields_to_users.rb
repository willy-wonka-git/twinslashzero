class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, null: false, default: "user"
    add_column :users, :nickname, :string, null: false
    add_column :users, :fullname, :string
    add_column :users, :description, :text

    add_index :users, :nickname, unique: true
  end
end
