class Ticket < ApplicationRecord
  validates :audience, uniqueness: { scope: %i[band event] }

  belongs_to :audience
  belongs_to :band
  belongs_to :event
end
