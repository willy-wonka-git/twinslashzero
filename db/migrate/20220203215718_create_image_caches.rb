class CreateImageCaches < ActiveRecord::Migration[6.1]
  def change
    create_table :image_caches do |t|
      t.references :post, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :key
      t.integer :order, default: 0, null: false

      t.timestamps
    end

    add_index :image_caches, [:post_id, :user_id]
    add_index :image_caches, [:post_id, :user_id, :key], unique: true
  end
end
