FactoryBot.define do
  factory :band, aliases: %i[owner performer follower followed] do
    name { 'Test Name' }
    sequence(:email) { |n| "teste#{n}@example.com" }
    password { 'testPassword' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_img.jpg')) }
    profile { 'This is the test profile' }
    website { 'http://example.com' }
    twitter { 'http://example.com/' }
  end
end
