class Friendship < ApplicationRecord
  validates :follower_id, uniqueness: { scope: :followed_id }

  belongs_to :follower, class_name: 'Band'
  belongs_to :followed, class_name: 'Band'
end
