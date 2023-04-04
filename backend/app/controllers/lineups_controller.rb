class LineupsController < ApplicationController
  before_action :authenticate_band!
  before_action :pass_event_owner

  def create
    lineup = Lineup.new(lineup_params)
    if lineup.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  def destroy
    lineup = Lineup.find_by!(lineup_params)
    if lineup.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def pass_event_owner
    current_band.created_events.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    head :forbidden
  end

  def lineup_params
    params.require(:lineup).permit(:event_id, :performer_id)
  end
end
