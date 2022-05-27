class LineupsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_event
  before_action :set_lineup, only: %i(update destroy)

  def index
    @bands = Band.all
    @lineups = @event.lineups
  end

  def create
    lineup = Lineup.new(lineup_params)
    if lineup.save
      render json: :created
    else
      render json: :unprocessable_entity
    end
  end

  def update
    if @lineup.update(lineup_params)
      render json: :ok
    else
      render json: :unprocessable_entity
    end
  end
  
  def destroy
    if @lineup.destroy
      render json: :ok
    else
      render json: :bad_request
    end
  end

  private

  def set_event
    #Event作成者か否かのチェックも兼ねる
    @event = current_band.created_events.find(params[:event_id])
  end

  def set_lineup
    @lineup = Lineup.find(params[:id])
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id)
  end
end
