class BandsController < ApplicationController
  include Accessable
  before_action ->{ pass_band_owner(params[:id]) }, only: %i[edit tickets]

  def index
    @bands = Band.all.order(:name)
  end

  def show
    @band = Band.find(params[:id])
  end

  def edit
    render json: current_band
  end

  def tickets
    @tickets = current_band.tickets
  end
end
