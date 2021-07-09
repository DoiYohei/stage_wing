class Lineup < ApplicationRecord
  validates :unregistered_performers, length: { maximum: 500 }, allow_blank: true

  belongs_to :performer, class_name: "Band", optional:true
  belongs_to :event
end
