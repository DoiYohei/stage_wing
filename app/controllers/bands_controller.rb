class BandsController < ApplicationController
  skip_before_action :authenticate_band!

  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
    lineups = Lineup.where(performer_id: params[:id])
    @events = lineups.map { |lineup| lineup.event }
    @image = @band.image.thumb.url
  end
end
