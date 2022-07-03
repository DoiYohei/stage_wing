FactoryBot.define do
  factory :band, aliases: [:owner, :performer, :follower, :followed] do
    name { "Test Name" }
    sequence(:email) { |n| "teste#{n}@example.com" }
    password { "testPassword" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/band-image.jpeg')) }
    profile { "This is the test profile"}
    website { "http://example.com" }
    twitter { "http://example.com/" }
  end
end
