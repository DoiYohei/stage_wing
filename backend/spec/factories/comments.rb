FactoryBot.define do
  factory :comment, aliases: [:parent] do
    content { 'test' }
    association :band, :event, :parent
  end
end
