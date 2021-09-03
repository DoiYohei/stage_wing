require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:band) { create(:band) }
  let(:post) { create(:post, band: band) }
  it "is valid with band and post" do
    like = build(:like, band: band, post: post)
    expect(like).to be_valid
  end
  it "is invalid without band_id" do
    like = Like.new(band_id: nil, post_id: post.id)
    like.valid?
    expect(like.errors[:band]).to include("can't be blank")
  end
  it "is invalid without post_id" do
    like = Like.new(band_id: band.id, post_id: nil)
    like.valid?
    expect(like.errors[:post]).to include("can't be blank")
  end
  it "is invalid with a duplicate combination of band and post" do
    create(:like, band: band, post: post)
    like = build(:like, band: band, post: post)
    like.valid?
    expect(like.errors[:band_id]).to include("has already been taken")
  end
  it "increases likes_count of the post by 1 when a like is created" do
    expect{ create(:like, band: band, post: post) }.to change{ post.likes_count }.by(1)
  end
end
