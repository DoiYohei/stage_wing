class Like < ApplicationRecord
  validates :band, presence: true
  validates :post, presence: true
  validates_uniqueness_of :band_id, scope: :post_id

  belongs_to :band
  belongs_to :post, counter_cache: true
end
