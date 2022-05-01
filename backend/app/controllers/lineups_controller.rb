class LineupsController < ApplicationController
  before_action :authenticate_band!, except: :index
  before_action :set_lineup, only: %i(update destroy)

  def index
    @bands = Band.all
    @event = Event.find(params[:event_id])
    @lineups = @event.lineups
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
    if @lineup.update(lineup_params)
      render json: :ok
    else
      render json: lineup.errors, status: :unprocessable_entity
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
    params.require(:lineup).permit(:event_id, :performer_id)
  end
end
