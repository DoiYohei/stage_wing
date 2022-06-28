class Lineup < ApplicationRecord
  validates_uniqueness_of :event, scope: :performer

  belongs_to :performer, class_name: "Band"
  belongs_to :event
end
