FactoryBot.define do
  factory :lineup do
    association :event, :performer
  end
end
