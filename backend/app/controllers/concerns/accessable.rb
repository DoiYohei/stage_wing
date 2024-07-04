module Accessable
  extend ActiveSupport::Concern

  def pass_band_owner(id)
    band = Band.find(id)
    if current_band != band
      render json: { error: 'You are not the owner of this band' }, status: :forbidden
    end
  end

  def pass_audience_owner(id)
    audience = Audience.find(id)
    if current_audience != audience
      render json: { error: 'You are not the owner of this audience' }, status: :forbidden
    end
  end
end
