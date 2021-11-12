class FriendshipsController < ApplicationController
  before_action :authenticate_band!
  
  def create
    band = Band.find(params[:followed_id])
    @friendship = current_band.follow(band)
    render json: @friendship, status: :created
  end

  def destroy
    current_band.unfollow(params[:followed_id])
    render json: :ok
  end
end
