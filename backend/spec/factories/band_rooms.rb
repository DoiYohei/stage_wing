FactoryBot.define do
  factory :band_room do
    association :band
    association :room
  end
end
