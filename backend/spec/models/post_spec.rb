require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:band) { create(:band) }
  it "is valid with a format, photo, description" do
    post = build(:post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a format, audio, description" do
    post = build(:post, :audio_post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a format, media_pass, description" do
    post = build(:post, :media_pass_post, band: band)
    expect(post).to be_valid
  end
  it "is valid with a format, description" do
    post = build(:post, :news_post, band: band)
    expect(post).to be_valid
  end
  it "is invalid without a format" do
    post = build(:post, format: nil, band: band)
    post.valid?
    expect(post.errors[:format]).to include("can't be blank")
  end
end
