class Lineup < ApplicationRecord
  validates :event, uniqueness: { scope: :performer }

  belongs_to :performer, class_name: "Band"
  belongs_to :event
end
