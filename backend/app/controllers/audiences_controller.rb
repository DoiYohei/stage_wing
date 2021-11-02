class AudiencesController < ApplicationController
  before_action :authenticate_audience!

  def show
    @audience = current_audience
  end
end
