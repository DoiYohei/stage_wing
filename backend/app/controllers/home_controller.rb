class HomeController < ApplicationController
  def index
    @events = Event.order(updated_at: :desc).limit(5)
    render json: @events
  end
end
