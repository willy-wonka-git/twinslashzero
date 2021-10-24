class AddIndexToTagging < ActiveRecord::Migration[6.1]
  def change
    add_index :taggings, [:tag_id, :post_id]
  end
end
