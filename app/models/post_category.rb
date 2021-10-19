class PostCategory < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 1000 }

  has_many :post
end
