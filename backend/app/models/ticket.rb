class Ticket < ApplicationRecord
  validates_uniqueness_of :audience_id, scope: %i(event_id band_id)

  belongs_to :audience
  belongs_to :event
  belongs_to :band
end
