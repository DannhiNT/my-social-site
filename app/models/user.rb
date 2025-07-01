class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one_attached :avatar

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create  do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = provider_data.info.name
      user.profile_image = provider_data.info.image
    end
  end

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    else
      profile_image || gravatar_url
    end
  end

  def gravatar_url
    hash = Digest::SHA256.hexdigest(email.strip.downcase)
    "https://gravatar.com/avatar/#{hash}?s=200&d=monsterid"
  end

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
