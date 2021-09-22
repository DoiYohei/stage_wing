class Event < ApplicationRecord
  validates :name, :place, length: { maximum: 50 }, presence:true
  validates :content, length: { maximum: 1000 }
  validates :unregistered_performers, length: { maximum: 500 }
  validates :open_at, :start_at, presence:true

  mount_uploader :flyer, ImageUploader

  belongs_to :owner, class_name: "Band"
  has_many :lineups, dependent: :destroy
  has_many :performers, class_name: "Band", through: :lineups
  has_many :comments, dependent: :destroy
end
