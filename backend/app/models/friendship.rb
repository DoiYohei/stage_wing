class Friendship < ApplicationRecord
  validates_uniqueness_of :follower_id, scope: :followed_id

  belongs_to :follower, class_name: "Band"
  belongs_to :followed, class_name: "Band"
end
