FactoryBot.define do
  factory :event do
    name { 'test' }
    flyer { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_img.jpg')) }
    place { 'test' }
    date { Date.current }
    open_at { Time.current }
    start_at { Time.current }
    ticket_price { 1 }
    content { 'test' }
    unregistered_performers { 'test' }
    reservation { true }
    association :owner
  end
end
