class User < ApplicationRecord
  extend Enumerize

  validates :nickname, presence: true, length: { minimum: 5, maximum: 30 }, uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 200 }

  enumerize :role, in: [:guest, :user, :admin], default: :user

  has_many :posts, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable
end
