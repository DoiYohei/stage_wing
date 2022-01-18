class BandsController < ApplicationController
  before_action :authenticate_band!, only: %i(edit friendships tickets)

  def index
    @bands = Band.all.order(:name)
  end

  def show
    @band = Band.find(params[:id])
    @performing_events = @band.performing_events.order(:open_at)
    if current_band
      @friend_status = current_band.friend_status(@band)
    end
  end

  def edit
    @band = Band.find(params[:id])
  end

  def friendships
    band = Band.find(params[:id])
    @friends = band.friends
    @inviting = band.inviting
    @inviters = band.inviters
  end

  def tickets
    @tickets = current_band.tickets
  end
end
