FactoryBot.define do
  factory :event do
    name { "Test Festival" }
    flyer { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/event-flyer.jpg')) }
    place { "Shibuya Test" }
    open_at { "2022-08-24 18:00" }
    start_at { "2022-08-24 18:30" }
    ticket_price { 1200 }
    content { "フェス開催します。フェス開催します。フェス開催します。フェス開催します。フェス開催します。フェス開催します。" }
    unregistered_performers { "The Testles" }
    association :owner
  end
end
