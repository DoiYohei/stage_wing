class FriendshipsController < ApplicationController
  def create
    band = Band.find(params[:followed_id])
    current_band.follow(band)
  end

  def destroy
    band = Friendship.find(params[:id]).followed
    current_band.unfollow(band)
  end
end
