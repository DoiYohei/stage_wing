class Event < ApplicationRecord
  validates :name, :place, length: { maximum: 50 }, presence:true
  validates :content, length: { maximum: 1000 }
  validates :unregistered_performers, length: { maximum: 1000 }
  validates :open_at, :start_at, :reservation, presence:true

  mount_uploader :flyer, ImageUploader

  belongs_to :owner, class_name: "Band", optional: true
  has_many :lineups, dependent: :destroy
  has_many :performers, class_name: "Band", through: :lineups
  has_many :comments, dependent: :destroy
  has_many :tickets, dependent: :destroy
end
