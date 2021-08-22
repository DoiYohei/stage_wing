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

  def  friends
    band = Band.find(params[:id])
    @mutual_followers = band.mutual_followers
    @sending_friend_request = band.sending_friend_request
    @receiving_friend_request = band.receiving_friend_request
  end
end
