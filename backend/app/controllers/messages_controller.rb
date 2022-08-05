class MessagesController < ApplicationController
  before_action :authenticate_band!

  def index
    room = current_band.rooms.find(params[:room_id])
    @messages = Message.where(room_id: room.id)
    band_room = BandRoom.find_by!(room_id: room.id, band_id: params[:band_id])
    @partner = band_room.band
    head :bad_request if current_band == @partner
  end
end
