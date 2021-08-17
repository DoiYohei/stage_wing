FactoryBot.define do
  factory :lineup do
    association :event
    association :performer
  end
end
