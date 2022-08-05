FactoryBot.define do
  factory :band_room do
    association :band, :room
  end
end
