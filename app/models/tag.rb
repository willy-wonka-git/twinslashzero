class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.create_new_tags(tag_ids)
    return unless tag_ids
    tag_ids.each_with_index do |tag_id, index|
      next unless tag_id.include?("#(new)")

      tag = Tag.find_or_create_by(name: tag_id.sub("#(new)", "").strip)
      tag.save unless tag.id
      tag_ids[index] = tag.id.to_s
    end
  end

  def self.tagged_with(name)
    tag = Tag.find_by(name: name)
    tag ? tag.posts.published : Post.published
  end

  def self.tag_counts
    Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
  end
end
