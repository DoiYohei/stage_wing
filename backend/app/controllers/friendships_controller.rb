class FriendshipsController < ApplicationController
  include Accessable
  before_action :authenticate_band!
  before_action :set_other_band, except: :index
  before_action ->{ pass_band_owner(params[:band_id]) } , only: :index

  def index
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
