FactoryBot.define do
  factory :message do
    association :band, :room
    content { 'test' }
  end
end
