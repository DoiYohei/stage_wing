class EventsController < ApplicationController
  before_action :authenticate_band!, except: %i(index show)
  before_action :set_event, only: %i(update destroy)

  def index
    @events = Event.all.order(:open_at)
  end

  def show
    @event = Event.find(params[:id])
    @flyer = @event.flyer.url
    @performers = @event.performers
    @comments = @event.comments
    @parent_comments = @comments.select { |n| n.parent_id == nil }
    if current_audience
      tickets = current_audience.tickets
      @ticket = tickets.find_by(event_id: @event.id)
    end
  end

  def create
    @event = current_band.created_events.build(event_params)
    @owner = @event.owner
    if @event.save
      render :show, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    @owner = @event.owner
    if @event.update(event_params)
      render :show, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
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
    params.require(:event).permit(:name, :flyer, :place, :open_at, :start_at, :content, :unregistered_performers, :reservation)
  end
end
