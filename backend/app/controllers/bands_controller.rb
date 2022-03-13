class BandsController < ApplicationController
  before_action :authenticate_band!, only: %i(edit friendships tickets)

  def index
    @bands = Band.all.order(:name)
  end

  def show
    @band = Band.find(params[:id])
    if current_band
      @friend_status = current_band.friend_status(@band)
      @rooms = current_band.fetch_rooms
    end
  end

  def edit
    @band = Band.find(params[:id])
  end

  def posts
    @posts = Post.where(band_id: params[:id]).newest
    if current_member
      @favorite_ids = current_member.likes.pluck(:post_id)
    end
  end

  def events
    band = Band.find(params[:id])
    @events = band.performing_events.order(:open_at)
  end

  def friendships
    band = Band.find(params[:id])
    @friends = band.friends
    @inviting = band.inviting
    @inviters = band.inviters
  end

  def tickets
    @events = current_band.performing_events
    @tickets = current_band.tickets
  end
end
