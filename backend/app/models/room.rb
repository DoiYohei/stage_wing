class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :band_rooms, dependent: :destroy
  has_many :bands, through: :band_rooms
end
