class BandsController < ApplicationController
  skip_before_action :authenticate_band!

  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
  end
end
