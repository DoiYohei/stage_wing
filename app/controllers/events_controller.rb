class EventsController < ApplicationController
  skip_before_action :authenticate_band!, only: [:index, :show]
  before_action :set_event, only: [:update, :destroy]

  def index
    @events = Event.where("open_at > ?", Time.zone.now).order(:open_at)
  end

  def show
    @event = Event.find(params[:id])
    @owner = @event.owner
  end

  def create
    @event = current_band.created_events.build(event_params)
    if @event.save
      render json: :created
    else
      render json: @event.error, status: :unprocessable_entity
    end
  end

  def update
    @owner = @event.owner
    if @event.update(event_params)
      render :show, status: :ok
    else
      render json: @event.error, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    render json: :ok
  end

  private

  def set_event
    @event = current_band.created_events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :place, :open_at, :start_at, :content)
  end
end
