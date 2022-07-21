class BandsController < ApplicationController
  before_action :accessible_by_owner, only: %i[edit tickets]

  def index
    @bands = Band.all.order(:name)
  end

  def show
    @band = Band.find(params[:id])
    @posts = @band.posts.newest
    @events = @band.performing_events.order(:open_at)
    if current_band
      @friend_status = current_band.friend_status(@band)
      @rooms = current_band.fetch_rooms
    end
    @favorite_ids = current_member.likes.pluck(:post_id) if current_member
  end

  def edit
    render json: current_band
  end

  def tickets
    @events = current_band.performing_events.order(:open_at)
    @tickets = current_band.tickets
  end

  private

  def accessible_by_owner
    head :unauthorized if current_band != Band.find(params[:id])
  end
end
