FactoryBot.define do
  factory :message do
    association :band
    association :room
    content { "test" }
  end
end
