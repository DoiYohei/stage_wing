FactoryBot.define do
  factory :ticket do
    association :audience
    association :event
    association :band
  end
end
