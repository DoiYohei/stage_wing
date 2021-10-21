class RoomsController < ApplicationController
  def index
    rooms = current_band.fetch_rooms
    render json: rooms
  end

  def create
    room = Room.create!
    current_band.band_rooms.create!(room_id: room.id)
    BandRoom.create!(band_room_params.merge(room_id: room.id))
    render json: room.id
  end

  private

  def band_room_params
    params.require(:band_room).permit(:band_id)
  end
end
