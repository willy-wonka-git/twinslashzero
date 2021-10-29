class User < ApplicationRecord
  extend Enumerize

  enumerize :role, in: [:guest, :user, :admin], default: :user
  has_many :posts, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  validates :nickname, presence: true, length: { minimum: 5, maximum: 30 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 200 }
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: I18n.t("errors.messages.must_be_valid_image_format") },
                     size: { less_than: 5.megabytes,
                             message: I18n.t("errors.messages.should_be_less_than_5mb") }

  # Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
  end

  def posts
    return Post.where(author: self) if User.current_user.admin?
    return Post.where(author: self) if User.current_user == self

    Post.published.where(author: self)
  end

  def avatar_key
    avatar.key || :noavatar
  end

  def admin?
    role == :admin
  end
end
