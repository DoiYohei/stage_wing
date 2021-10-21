class BandRoom < ApplicationRecord
  validates :band, presence: true
  validates :room, presence: true
  validates_uniqueness_of :room_id, scope: :band_id

  belongs_to :band
  belongs_to :room
end
