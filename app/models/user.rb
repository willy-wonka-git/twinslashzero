require 'uri'

class User < ApplicationRecord
  extend Enumerize

  enumerize :role, in: [:guest, :user, :admin], default: :user
  has_many :posts, inverse_of: 'author', foreign_key: "author_id", dependent: :destroy
  has_many :post_history, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  validates :nickname, presence: true, length: { minimum: 5, maximum: 30 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 200 }
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: I18n.t("errors.messages.must_be_valid_image_format") },
                     size: { less_than: 5.megabytes,
                             message: I18n.t("errors.messages.should_be_less_than_5mb") }

  # Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:twitter, :vkontakte]

  def self.from_vkontakte_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.extra.raw_info.screen_name}@vk.com"
      user.password = Devise.friendly_token[0, 20]
      user.fullname = auth.info.name
      user.nickname = auth.extra.raw_info.screen_name
      file = URI.parse(auth.info.image).open
      user.avatar.attach(io: file, filename: "vk#{auth.uid}.jpg")
    end
  end

  def self.from_twitter_omniauth(auth)
    Rails.logger.debug auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.extra.raw_info.screen_name}@twitter.com"
      user.password = Devise.friendly_token[0, 20]
      user.fullname = auth.info.name
      user.nickname = auth.info.nickname
      file = URI.parse(auth.info.image).open
      user.avatar.attach(io: file, filename: "twitter#{auth.uid}.jpg")
    end
  end

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
