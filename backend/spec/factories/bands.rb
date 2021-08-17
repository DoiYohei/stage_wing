FactoryBot.define do
  factory :band, aliases: [:owner, :performer] do
    name { "The Examples" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "testPassword" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/band-image.jpeg')) }
    profile { "テストバンドです。テストバンドです。テストバンドです。テストバンドです。テストバンドです。テストバンドです。"}
    website { "http://example.com" }
    twitter { "http://example.net/" }
  end
end
