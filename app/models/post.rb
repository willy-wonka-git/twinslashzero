class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category, class_name: "PostCategory"
  has_many :taggings
  has_many :tags, through: :taggings

  default_scope -> { order(published_at: :desc, created_at: :desc) }

  validates :category, :title, :content, presence: true
  validates :title, length: { minimum: 5, maximum: 200 }
  validates :content, length: { minimum: 50, maximum: 2000 }

  def self.tagged_with(name)
    tag = Tag.find_by(name: name)
    tag ? tag.posts.published : Post.published
  end

  def self.tag_counts
    Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def self.published
    self.where.not(published_at: nil)
  end
end
