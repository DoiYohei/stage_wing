class LineupsController < ApplicationController
  skip_before_action :authenticate_band!, only: :index
  before_action :set_lineup, only: [:update, :destroy]

  def index
    @performers = []
    @lineup_ids = []
    @lineups = Lineup.where(event_id: params[:event_id])
    @lineups.each do |lineup|
      if lineup.performer
        @performers.push(lineup.performer)
        @lineup_ids.push(lineup.id)
      else
        @other_performer = lineup
      end
    end
    @event = Event.find(params[:event_id])
  end

  def create
    #複数のレコードが配列で送られてくるので、一つづつ処理する
    @lineups = []
    params.require(:lineups).each do |lineup|
      permitted = lineup_permit(lineup)
      new_lineup = Lineup.new(permitted)
      @lineups.push(new_lineup)
    end
    if @lineups.each{|lineup| lineup.save}
      render json: :created
    else
      render json: lineup.errors, status: :unprocessable_entity
    end
  end

  def update
    if @lineup.update(lineup_params)
      render json: :ok
    else
      render json: @lineup.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    @lineup.destroy!
    render json: :ok
  end

  private

  def lineup_permit(params)
    params.permit(:event_id, :performer_id, :unregistered_performers)
  end

  def set_lineup
    @lineup = Lineup.find(params[:id])
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id, :unregistered_performers)
  end
end
