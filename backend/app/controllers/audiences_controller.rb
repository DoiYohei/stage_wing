class AudiencesController < ApplicationController
  before_action :accessible_by_owner

  def edit
    render json: current_audience
  end

  def tickets
    @tickets = current_audience.tickets
  end

  private

  def accessible_by_owner
    head :unauthorized if current_audience != Audience.find(params[:id])
  end
end
