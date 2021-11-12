class Like < ApplicationRecord
  validates :post, :band_or_audience, presence: true
  validates_uniqueness_of :post_id, { scope: %i(band_id audience_id) }

  belongs_to :band, optional: true
  belongs_to :audience, optional: true
  belongs_to :post, counter_cache: true

  private

  def band_or_audience
    band.present? ^ audience.present?
  end
end
