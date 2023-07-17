class Post < ApplicationRecord
  validates :media_pass, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 20 }, allow_nil: true
  validates :description, length: { maximum: 500 }
  validates :format, presence: true

  mount_uploader :photo, ImageUploader
  mount_uploader :audio, AudioUploader

  scope :newest, -> { order(created_at: :desc) }

  belongs_to :band
  has_many :likes, dependent: :destroy
end
