FactoryBot.define do
  factory :audience do
    name { "test" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "testPassword" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/band-image.jpeg')) }
  end
end
