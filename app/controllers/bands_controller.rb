class BandsController < ApplicationController
  skip_before_action :authenticate_band!

  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
    performings = Lineup.where(performer_id: params[:id])
    @performing_events = Event.where(performings)
  end
end
