class EventsController < ApplicationController
  before_action :authenticate_band!, except: %i(index show)
  before_action :set_event, only: %i(edit update destroy)

  def create
    @event = current_band.created_events.build(event_params)
    if @event.save
      render json: { id: @event.id }, status: :created
    else
      head :unprocessable_entity
    end
  end

  def index
    @events = Event.all.order(:open_at)
  end

  def show
    @event = Event.find(params[:id])
    @all_comments = @event.comments
    @parent_comments = @all_comments.select { |n| n.parent_id == nil }
    if current_audience
      @ticket = @event.tickets.find_by(audience_id: current_audience.id)
    end
  end

  def edit
    render json: @event
  end

  def update
    if @event.update(event_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def set_event
    @event = current_band.created_events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :flyer, :place, :ticket_price, :open_at, :start_at, :content, :unregistered_performers, :reservation)
  end
end
