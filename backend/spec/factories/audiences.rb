FactoryBot.define do
  factory :audience do
    name { "Test Audience" }
    sequence(:email) { |n| "audience#{n}@example.com" }
    password { "passwordExample" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/band-image.jpeg')) }
  end
end
