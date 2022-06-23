class RoomsController < ApplicationController
  before_action :authenticate_band!
  
  def index
    if current_band == Band.find(params[:band_id])
      rooms = current_band.fetch_rooms
      render json: rooms
    else
      head :unauthorized
    end
  end

  def create
    room = Room.create!
    band_room = current_band.band_rooms.build(room_id: room.id)
    if band_room.save
      other_band_room = BandRoom.new(band_room_params.merge(room_id: room.id))
      if other_band_room.save
        render json: room.id, status: :created
      else
        head :unprocessable_entity
      end
    else
      head :bad_request
    end
  end

  private

  def band_room_params
    params.require(:band_room).permit(:band_id)
  end
end
