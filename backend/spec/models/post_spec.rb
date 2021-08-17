require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:band) { FactoryBot.create(:band) }
  it "is valid with a title, format, photo, description" do
    post = FactoryBot.build(:post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a title, format, audio, description" do
    post = FactoryBot.build(:post, :audio_post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a title, format, media_pass, description" do
    post = FactoryBot.build(:post, :media_pass_post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a title, format, description" do
    post = FactoryBot.build(:post, :news_post, band: band)
    expect(post).to be_valid
  end
  it "is invalid without a format" do
    post = FactoryBot.build(:post, format: nil, band: band)
    post.valid?
    expect(post.errors[:format]).to include("can't be blank")
  end
end
