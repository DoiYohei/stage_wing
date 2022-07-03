class Like < ApplicationRecord
  include UserValidator

  validates_uniqueness_of :post, scope: %i(band audience)

  belongs_to :post, counter_cache: true
end
