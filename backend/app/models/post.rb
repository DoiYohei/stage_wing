class Post < ApplicationRecord
  validates :media_pass, format: { with: /\A[a-zA-Z0-9]+\z/ }, length: { maximum: 20 }, allow_nil: true
  validates :description, length: { maximum: 100 }
  validates :format, :band_id, presence: true
  
  mount_uploader :photo, ImageUploader
  mount_uploader :audio, AudioUploader
  
  scope :newest, -> { order(created_at: :desc) }

  belongs_to :band
  has_many :likes, dependent: :destroy
  has_many :liking_bands, through: :likes, source: :band
end
