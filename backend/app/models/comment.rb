class Comment < ApplicationRecord
  include UserValidator

  validates :content, presence: true, length: { maximum: 1000 }

  belongs_to :event
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, inverse_of: 'parent', dependent: :destroy
end
