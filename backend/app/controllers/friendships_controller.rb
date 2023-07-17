class FriendshipsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_other_band, except: :index

  def index
    head :forbidden if current_band != Band.find_by(id: params[:band_id])
  end

  def create
    if current_band.following?(@band)
      head :bad_request
    else
      current_band.follow(@band)
      head :created
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
