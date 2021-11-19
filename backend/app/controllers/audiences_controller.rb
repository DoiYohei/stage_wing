class AudiencesController < ApplicationController
  before_action :authenticate_audience!, except: :index

  def show
    @audience = current_audience
    @image = @audience.image.thumb.url
  end

  def index
    @audiences = Audience.all
  end

  def tickets
    @tickets = current_audience.tickets
  end
end
