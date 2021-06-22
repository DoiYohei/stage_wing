class Post < ApplicationRecord
  belongs_to :band
  scope :newest, -> { order(created_at: :desc) }
  validates :band_id, presence: true

  mount_uploader :photo, ImageUploader
  mount_uploader :audio, AudioUploader
end
