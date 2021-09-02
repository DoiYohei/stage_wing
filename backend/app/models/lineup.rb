class Lineup < ApplicationRecord
  validates :event, presence: true
  validates :performer, presence: true
  validates_uniqueness_of :event_id, scope: :performer_id

  belongs_to :performer, class_name: "Band"
  belongs_to :event
end
