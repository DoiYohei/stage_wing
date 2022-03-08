class FriendshipsController < ApplicationController
  before_action :authenticate_band!
  
  def create
    current_band.follow(params[:followed_id])
    render json: :created
  end

  def destroy
    current_band.unfollow(params[:followed_id])
    render json: :ok
  end
end
