class AudiencesController < ApplicationController
  before_action :authenticate_audience!, only: :show

  def show
    @audience = current_audience
    @image = @audience.image.thumb.url
  end

  def index
    @audiences = Audience.all
  end
end
