class MessagesController < ApplicationController
  before_action :authenticate_band!

  def index
    head :bad_request if current_band.id == params[:band_id]
    room = current_band.rooms.find(params[:room_id])
    @band_room = BandRoom.find_by!(room_id: room.id, band_id: params[:band_id])
    @messages = Message.where(room_id: room.id)
  end
end
