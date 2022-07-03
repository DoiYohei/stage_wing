FactoryBot.define do
  factory :friendship do
    association :follower, :followed
  end
end
