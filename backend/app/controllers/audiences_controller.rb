class AudiencesController < ApplicationController
  before_action :authenticate_audience!, except: :index
  
  def index
    @audiences = Audience.all
  end
  
  def edit
    @audience = current_audience
  end
  
  def tickets
    @tickets = current_audience.tickets
  end
end
