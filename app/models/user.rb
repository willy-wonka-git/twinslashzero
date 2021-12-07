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
    get_user(auth, nickname: auth.extra.raw_info.screen_name)
  end

  def self.from_twitter_omniauth(auth)
    get_user(auth, nickname: auth.info.nickname)
  end

  def avatar_key
    avatar.key || :noavatar
  end

  def admin?
    role == :admin
  end

  def self.set_user(auth, user)
    user.email = auth.info.email || "#{auth.extra.raw_info.screen_name}@#{auth.provider}.com"
    user.password = Devise.friendly_token[0, 20]
    user.fullname = auth.info.name
  end

  def self.set_user_avater(auth, user)
    file = URI.parse(auth.info.image).open
    user.avatar.attach(io: file, filename: "#{auth.provider}#{auth.uid}.jpg")
  end

  def self.get_user(auth, params)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      User.set_user(auth, user)
      User.set_user_avater(auth, user)
      user.nickname = params[:nickname]
    end
  end
end
