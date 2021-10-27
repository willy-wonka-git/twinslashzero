class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper
  include AASM

  belongs_to :author, class_name: "User"
  belongs_to :category, class_name: "PostCategory"
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many_attached :photos, dependent: :destroy

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
    where(aasm_state: :approved)
  end

  def self.not_moderated
    where.not(aasm_state: [:banned, :draft, :approved, :archived])
  end

  def time_ago
    published_at ? time_ago_in_words(published_at) : ''
  end

  def published?
    aasm_state == :published
  end

  aasm do
    after_all_transitions :log_status_change

    state :draft, initial: true, display: I18n.t('posts.states.draft')
    state :new, display: I18n.t('posts.states.new')
    state :banned, display: I18n.t('posts.states.banned')
    state :approved, display: I18n.t('posts.states.approved')
    state :published, display: I18n.t('posts.states.published')
    state :archived, display: I18n.t('posts.states.archived')

    event :draft do
      transitions from: [:new, :approved, :published], to: :draft
    end

    event :moderate do
      transitions from: :draft, to: :new
    end

    event :reject do
      transitions from: :new, to: :draft, guard: :can_moderate?
      transitions from: :new, to: :banned, guard: :can_moderate?
    end

    event :ban do
    end

    event :approve do
      transitions from: :new, to: :approved, guard: :can_moderate?
    end

    event :publish do
      transitions from: :approved, to: :published
    end

    event :edit do
      transitions from: [:approved, :published, :archived], to: :draft
    end

    event :archive do
      transitions from: [:approved, :published], to: :archived
    end
  end  

  def log_status_change
    # puts "Changed from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
  end

  def can_moderate?
    can? :moderate, self
  end   
end
