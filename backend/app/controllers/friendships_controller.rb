class FriendshipsController < ApplicationController
  before_action :authenticate_band!
  
  def create
    if current_band.follow(params[:followed_id])
      render json: :created
    else
      render json: :bad_request
  end

  def destroy
    if current_band.unfollow(params[:followed_id])
      render json: :created
    else
      render json: :bad_request
  end
end
