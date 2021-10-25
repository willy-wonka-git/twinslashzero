class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :author, class_name: "User"
  belongs_to :category, class_name: "PostCategory"
  has_many :taggings
  has_many :tags, through: :taggings
  has_many_attached :photos

  default_scope -> { order(published_at: :desc, created_at: :desc) }

  validates :category, :title, :content, presence: true
  validates :title, length: { minimum: 5, maximum: 200 }
  validates :content, length: { minimum: 50, maximum: 2000 }
  validates :photos, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: I18n.t("errors.messages.must_be_valid_image_format") },
                     size: { less_than: 5.megabytes,
                             message: I18n.t("errors.messages.should_be_less_than_5mb") }

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
    where.not(published_at: nil)
  end

  def self.not_published
    where(published_at: nil)
  end

  def time_ago
    published_at ? time_ago_in_words(published_at) : ''
  end
end
