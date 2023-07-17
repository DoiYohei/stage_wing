module UserPresenceValidatable
  extend ActiveSupport::Concern

  included do
    validates :band_or_audience, presence: true

    belongs_to :band, optional: true
    belongs_to :audience, optional: true
  end

  def band_or_audience
    band.present? ^ audience.present?
  end
end
