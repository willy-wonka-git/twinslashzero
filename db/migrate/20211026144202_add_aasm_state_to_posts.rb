class AddAasmStateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :aasm_state, :string
  end

  def self.down
    remove_column :posts, :aasm_state
  end
end
