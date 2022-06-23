class FriendshipsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_other_band, except: :index
  
  def index
    if current_band == Band.find(params[:band_id])
      @friends = current_band.friends
      @inviting = current_band.inviting
      @inviters = current_band.inviters
    else
      head :unauthorized
    end
  end

  def create
    if !current_band.following?(@band) 
      current_band.follow(@band)
      head :created
    else
      head :bad_request
    end
  end

  def destroy
    if current_band.following?(@band)
      current_band.unfollow(@band)
      head :ok
    else
      head :bad_request
    end
  end

  private

  def set_other_band
    @band = Band.find(params[:followed_id])
  end
end
