class PostCategory < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 1000 }

  has_many :post, inverse_of: 'category', foreign_key: "category_id", dependent: :destroy

  def posts_published
    Post.published.where(category: self)
  end

  def posts
    Post.published.where(category: self)
  end
end
