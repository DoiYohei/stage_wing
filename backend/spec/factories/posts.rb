FactoryBot.define do
  factory :post do
    # 画像ファイル投稿
    format { 'photo' }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_img.jpg')) }
    audio { nil }
    media_pass { nil }
    description { 'test' }
    association :band

    # 音声ファイル投稿
    trait :audio_post do
      format { 'audio' }
      photo { nil }
      audio { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_audio.mp3')) }
      media_pass { nil }
    end

    # YouTube埋め込み投稿
    trait :media_pass_post do
      format { 'youtube' }
      photo { nil }
      audio { nil }
      media_pass { 'Test1' }
    end

    # news投稿
    trait :news_post do
      format { 'news' }
      photo { nil }
      audio { nil }
      media_pass { nil }
    end
  end
end
