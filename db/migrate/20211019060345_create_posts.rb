class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :author, index: true, foreign_key: { to_table: :users }, null: false
      t.references :category, index: true, foreign_key: { to_table: :post_categories }, null: false
      t.datetime :published_at
      t.string :title, index: true, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
