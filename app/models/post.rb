class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper
  include AASM

  belongs_to :author, class_name: "User"
  belongs_to :category, class_name: "PostCategory"
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many_attached :photos, dependent: :destroy
  has_many :post_history, dependent: :destroy

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
    where(aasm_state: :published)
  end

  def self.not_moderated
    where(aasm_state: [:new, :approved])
  end

  def created
    created_at.strftime("%D %H:%M")
  end

  def published
    published_at&.strftime("%D %H:%M")
  end

  def time_ago
    published_at ? time_ago_in_words(published_at) : ''
  end

  def published?
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
    User.current_user.admin?
  end

  def can_edit?
    author == User.current_user
  end

  def permitted_states
    aasm.events(permitted: true).map(&:name)
  end

  def post_history
    PostHistory.where(post: self).limit(10)
  end
end
