class CreatePostHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :post_history do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :state, null: false
      t.text :reason

      t.timestamps
    end
  end
end
