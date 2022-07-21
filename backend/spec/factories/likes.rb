FactoryBot.define do
  factory :like do
    association :band, :post
  end
end
