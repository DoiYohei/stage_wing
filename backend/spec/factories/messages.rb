FactoryBot.define do
  factory :message do
    association :band
    association :room
    content { "MyText" }
  end
end
