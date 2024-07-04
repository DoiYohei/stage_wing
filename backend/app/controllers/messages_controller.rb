class MessagesController < ApplicationController
  before_action :authenticate_band!

  def index
    room = current_band.rooms.find(params[:room_id])
    @messages = Message.where(room_id: room.id)
    @band = Band.find(params[:band_id])
  end
end
