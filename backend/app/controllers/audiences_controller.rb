class AudiencesController < ApplicationController
  include Accessable
  before_action ->{ pass_audience_owner(params[:id]) }

  def edit
    render json: current_audience
  end

  def tickets
    @tickets = current_audience.tickets
  end
end
