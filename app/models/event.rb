class Event < ApplicationRecord
  validates :name, length: { maximum: 50 }, presence:true
  validates :place, length: { maximum: 50 }, presence:true
  validates :content, length: { maximum: 1000 }
  validates :open_at, presence:true
  validates :start_at, presence:true

  mount_uploader :flyer, ImageUploader

  belongs_to :owner, class_name: "Band"
  has_many :lineups, dependent: :destroy
  has_many :performers, class_name: "Band", through: :lineups
end
