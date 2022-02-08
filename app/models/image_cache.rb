class ImageCache < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :key, presence: true, uniqueness: { scope: [:post_id, :user_id] }

  before_save :set_order
  before_destroy :remove_file

  def attachment?
    key.exclude?('cache_')
  end

  def set_order
    return unless order.zero?

    max_order = ImageCache.where(post: post, user: user).maximum('order') || 0
    self.order = max_order + 1
  end

  # cron

  def self.delete_old_cache
    ImageCache.where(["created_at <= ?", 2.hours.ago]).destroy_all
  end

  private

  def remove_file
    return if attachment?

    path = File.join(cache_path, File.basename(key))
    File.delete(path) if File.exist?(path)
  end

  def cache_path
    File.join(Rails.root.join("public", "uploads", user.id.to_s), "photos")
  end
end
