class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_follows,  -> { where(status: "accepted") }, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows,  -> { where(status: "accepted") }, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :pending_active_follows,  -> { where(status: "pending") }, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :pending_passive_follows,  -> { where(status: "pending") }, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  # Users this user follows (accepted)
  has_many :followings, through: :active_follows, source: :followed
  # Users following this user (accepted)
  has_many :followers, through: :passive_follows, source: :follower
  # Users this user follows (pending)
  has_many :pending_followings, through: :pending_active_follows, source: :followed
  # Users following this user (pending)
  has_many :pending_followers, through: :pending_passive_follows, source: :follower

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
end
