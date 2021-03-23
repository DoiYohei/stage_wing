class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_event, only: [:update, :destroy]

  def index
    @events = Event.where("open_at > ?", Time.zone.now).order(update_at: :desc)
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    event = current_user.created_events.build(event_params)
    if event.save
      render status: :created
    else
      render json: event.error, status: :unprocessable_entity
    end
  end

  def update
    if event.update(event_params)
      render status: :ok
    else
      render json: event.error, status: :unprocessable_entity
    end
  end

  def destroy
    event.destroy!
    render status: :ok
  end

  private

  def set_event
    event = current_user.created_events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :place, :content, :open_at, :start_at)
  end
end
