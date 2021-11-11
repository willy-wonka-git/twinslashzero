class Tagging < ApplicationRecord
  belongs_to :post, dependent: :destroy
  belongs_to :tag, dependent: :destroy
end
