FactoryBot.define do
  factory :post do
    # 画像ファイル投稿
    title { "投稿テスト" }
    format { "photo" }
    photo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/post-photo.jpeg')) }
    audio { nil }
    media_pass { nil }
    description { "投稿テストです。投稿テストです。投稿テストです。投稿テストです。投稿テストです。投稿テストです。"}
    association :band

    # 音声ファイル投稿
    trait :audio_post do
      format { "audio" }
      photo { nil }
      audio { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/post-audio.wav')) }
      media_pass { nil }
    end

    # YouTube埋め込み投稿
    trait :media_pass_post do
      format { "youtube" }
      photo { nil }
      audio { nil }
      media_pass { "1a2B34cdEF" }
    end

    # news投稿
    trait :news_post do
      format { "news" }
      photo { nil }
      audio { nil }
      media_pass { nil }
    end
  end
end
