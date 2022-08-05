class BandRoom < ApplicationRecord
  validates :room, uniqueness: { scope: :band }

  belongs_to :band
  belongs_to :room
end
