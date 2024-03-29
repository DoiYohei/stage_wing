class Event < ApplicationRecord
  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 50 }
  validates :content, :unregistered_performers, length: { maximum: 1000 }
  validates :date, presence: true
  validates :reservation, inclusion: { in: [true, false] }

  mount_uploader :flyer, ImageUploader

  belongs_to :owner, class_name: 'Band', optional: true
  has_many :lineups, dependent: :destroy
  has_many :performers, class_name: 'Band', through: :lineups
  has_many :comments, dependent: :destroy
  has_many :tickets, dependent: :destroy
end
