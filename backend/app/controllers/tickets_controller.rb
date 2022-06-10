class TicketsController < ApplicationController
  before_action :authenticate_audience!

  def create
    ticket = current_audience.tickets.build(ticket_params)
    if ticket.save
      render json: :created
    else
      render json: :unprocessable_entity
    end
  end

  def destroy
    ticket = current_audience.tickets.find(params[:id])
    if ticket.destroy
      render json: :ok
    else
      render json: :bad_request
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:event_id, :band_id)
  end
end
