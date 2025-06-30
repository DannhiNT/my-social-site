class Follow < ApplicationRecord
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :status, inclusion: { in: [ "pending", "accepted" ] }

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
