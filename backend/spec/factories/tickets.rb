FactoryBot.define do
  factory :ticket do
    association :audience, :band, :event
  end
end
