class PostHistory < ApplicationRecord
  self.table_name = "post_history"

  belongs_to :user
  belongs_to :post
end
