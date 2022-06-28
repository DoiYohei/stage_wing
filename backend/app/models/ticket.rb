class Ticket < ApplicationRecord
  validates_uniqueness_of :audience, scope: %i(band event)

  belongs_to :audience
  belongs_to :band
  belongs_to :event
end
