FactoryBot.define do
  factory :event do
    name { "test" }
    flyer { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/event-flyer.jpg')) }
    place { "test" }
    open_at { Time.now }
    start_at { Time.now }
    ticket_price { 1 }
    content { "test" }
    unregistered_performers { "test" }
    reservation { true }
    association :owner
  end
end
