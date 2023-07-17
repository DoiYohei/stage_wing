class AudiencesController < ApplicationController
  before_action :pass_account_owner

  def edit
    render json: current_audience
  end

  def tickets
    @tickets = current_audience.tickets
  end

  private

  def pass_account_owner
    head :forbidden if current_audience != Audience.find_by(id: params[:id])
  end
end
