class LineupsController < ApplicationController
  before_action :set_lineup, only: [:update, :destroy]

  def create
    @lineup = Lineup.new(lineup_params)
    if @lineup.save
      render json: :created
    else
      render json: @lineup.error, status: :unprocessable_entity
    end
  end
  
  def updata
    if @lineup.update(lineup_params)
      render json: :ok
    else
      render json: @lineup.error, status: :unprocessable_entity
    end
  end
  
  def destroy
    @lineup.destroy!
    render json: :ok
  end

  private

  def set_lineup
    @lineup = Lineup.find(params[:id])
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id, :unregistered_performers)
  end
end
