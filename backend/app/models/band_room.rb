class BandRoom < ApplicationRecord
  validates_uniqueness_of :room, scope: :band

  belongs_to :band
  belongs_to :room
end
