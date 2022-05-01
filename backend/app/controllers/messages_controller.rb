class MessagesController < ApplicationController
  before_action :authenticate_band!
  
  def index
    @messages = Message.where(room_id: params[:room_id])
    @partner = Band.find(params[:band_id])
  end
end
