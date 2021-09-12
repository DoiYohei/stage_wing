FactoryBot.define do
  factory :comment, aliases: [:parent] do
    content { "テストコメント" }
    association :band, :event, :parent
  end
end
