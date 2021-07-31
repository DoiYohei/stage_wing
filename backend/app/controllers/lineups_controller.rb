class LineupsController < ApplicationController
  skip_before_action :authenticate_band!, only: :index
  before_action :set_lineup, only: [:update, :destroy]

  def index
    @performers = []
    @lineup_ids = []
    @lineups = Lineup.where(event_id: params[:event_id])
    @lineups.each do |lineup|
      @performers.push(lineup.performer)
      @lineup_ids.push(lineup.id)
    end
  end

  def create
    lineup = Lineup.new(lineup_params)
    if lineup.save
      render json: :created
    else
      render json: lineup.errors, status: :unprocessable_entity
    end
  end

  def update
    if lineup.update(lineup_params)
      render json: :ok
    else
      render json: lineup.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    lineup.destroy!
    render json: :ok
  end

  private

  def set_lineup
    lineup = Lineup.find(params[:id])
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id)
  end
end
