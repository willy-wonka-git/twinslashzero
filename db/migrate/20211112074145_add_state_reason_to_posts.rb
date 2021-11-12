class AddStateReasonToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :state_reason, :string
  end

  def self.down
    remove_column :posts, :state_reason
  end
end
