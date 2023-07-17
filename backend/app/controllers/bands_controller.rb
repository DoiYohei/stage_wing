class BandsController < ApplicationController
  before_action :pass_account_owner, only: %i[edit tickets]

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

  private

  def pass_account_owner
    head :forbidden if current_band != Band.find_by(id: params[:id])
  end
end
