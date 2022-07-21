FactoryBot.define do
  factory :audience do
    name { 'test' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'testPassword' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_img.jpg')) }
  end
end
