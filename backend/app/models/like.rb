class Like < ApplicationRecord
  include UserValidator

  validates :post, uniqueness: { scope: %i[band audience] }

  belongs_to :post, counter_cache: true
end
