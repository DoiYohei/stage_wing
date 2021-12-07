class BandsController < ApplicationController
  before_action :authenticate_band!, only: %i(friendships tickets)

  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
    lineups = Lineup.where(performer_id: params[:id])
    @events = lineups.map { |lineup| lineup.event }
    @image = @band.image.url
    if current_band
      @friend_status = current_band.friend_status(@band)
    end
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
