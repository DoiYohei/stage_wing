FactoryBot.define do
  factory :like do
    association :band
    association :post
  end
end
