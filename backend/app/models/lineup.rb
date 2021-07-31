class Lineup < ApplicationRecord
  belongs_to :performer, class_name: "Band", optional:true
  belongs_to :event
end
