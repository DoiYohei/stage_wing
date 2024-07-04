class RoomsController < ApplicationController
  include Accessable
  before_action :authenticate_band!
  before_action ->{ pass_band_owner(params[:band_id]) }, only: :index

  def index
    rooms = current_band.fetch_rooms
    render json: rooms, status: :ok
  end

  def create
    band = Band.find(band_room_params[:band_id])
    return head :forbidden if !current_band.friends.include?(band)
    return head :unprocessable_entity if current_band.has_room_with?(band)
    result = current_band.create_room_with(band)
    if result.is_a?(Room)
      render json: result.id, status: :created
    else
      head :internal_server_error
    end
  end

  private

  def band_room_params
    params.require(:band_room).permit(:band_id)
  end
end
