class LineupsController < ApplicationController
  before_action :authenticate_band!
  before_action :set_event
  before_action :set_lineup, only: %i(update destroy)

  def index # Lineups編集時に使用
    @bands = Band.all
    @lineups = @event.lineups
  end

  def create
    lineup = Lineup.new(lineup_params)
    if lineup.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def update
    if @lineup.update(lineup_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end
  
  def destroy
    if @lineup.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def set_event
    @event = current_band.created_events.find(params[:event_id])
  end

  def set_lineup
    @lineup = Lineup.find(params[:id])
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id)
  end
end
