class CreatePostCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :post_categories do |t|
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :post_categories, :title, unique: true
  end
end
