class Post < ApplicationRecord
  include ApplicationHelper
  include ActionView::Helpers::DateHelper
  include AASM

  belongs_to :author, class_name: "User"
  belongs_to :category, class_name: "PostCategory"
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  has_many_attached :photos, dependent: :destroy
  has_many :post_history, dependent: :delete_all

  validates :title, length: { minimum: 5, maximum: 200 }
  validates :content, length: { minimum: 50, maximum: 2000 }
  validates :photos, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: I18n.t("errors.messages.must_be_valid_image_format") },
                     size: { less_than: 5.megabytes,
                             message: I18n.t("errors.messages.should_be_less_than_5mb") }

  validates :author, :category, :title, :content, presence: true

  before_save :set_published_at
  after_save :save_post_history

  scope :published, -> { where(aasm_state: :published).order(published_at: :desc, created_at: :desc) }
  scope :not_moderated, -> { where(aasm_state: [:new]).order(created_at: :desc) }
  scope :by_author, ->(author) { where(author_id: author.id).order(created_at: :desc) }

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def created
    created_at.strftime("%d/%m/%Y %R")
  end

  def published_format
    published_at&.strftime("%D %H:%M")
  end

  def time_ago
    published_at ? time_ago_in_words(published_at) : ''
  end

  def state_published?
    aasm_state == :published
  end

  aasm do
    state :draft, initial: true, display: I18n.t('posts.states.draft')
    state :new, display: I18n.t('posts.states.new')
    state :banned, display: I18n.t('posts.states.banned')
    state :approved, display: I18n.t('posts.states.approved')
    state :published, display: I18n.t('posts.states.published')
    state :archived, display: I18n.t('posts.states.archived')

    event :draft do
      transitions from: [:new, :approved, :published, :archived], to: :draft, guard: :can_edit?
    end

    event :run do
      transitions from: :draft, to: :new, guard: :can_edit?
    end

    event :reject do
      transitions from: [:new, :approved, :published, :archived], to: :draft, guard: :can_moderate?
    end

    event :ban do
      transitions from: [:new, :approved, :published, :archived], to: :banned, guard: :can_moderate?
    end

    event :approve do
      transitions from: :new, to: :approved, guard: :can_moderate?
    end

    event :publish do
      transitions from: :approved, to: :published, guard: :can_moderate?
    end

    event :archive do
      transitions from: [:approved, :published], to: :archived, guard: :can_moderate? || :can_edit?
    end
  end

  def can_moderate?
    Current.user&.admin?
  end

  def can_edit?
    author == Current.user
  end

  def permitted_states
    aasm.events(permitted: true).map(&:name)
  end

  def post_history(limit = 10)
    history = PostHistory.where(post: self).order(created_at: :desc)
    history = history.limit(limit) if limit
    history
  end

  def save_post_history
    return if post_history.first && post_history.first.state == aasm.current_state.to_s
    return unless Current.user

    post_history = PostHistory.create({ post: self, user: Current.user, state: aasm.current_state })
    post_history.reason = state_reason
    post_history.save
  end

  def set_published_at
    self.published_at = aasm_state == :published.to_s ? Time.zone.now : nil
  end

  # cron tasks

  def self.publish_approved
    where(aasm_state: "approved").each do |post|
      post.publish
      post.published_at = Time.zone.now
      post.save
    end
  end

  def self.archive_published
    published.where(["published_at <= ?", 3.days.ago]).find_each do |post|
      post.archive
      post.save
    end
  end
end
