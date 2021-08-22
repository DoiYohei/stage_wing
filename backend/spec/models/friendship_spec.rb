require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:band1) { create(:band) }
  let(:band2) { create(:band) }
  it "is valid with follower_id and followed_id" do
    friendship = Friendship.new(follower_id: band1.id, followed_id: band2.id)
    expect(friendship).to be_valid
  end
  it "is invalid without follower_id" do
    friendship = Friendship.new(follower_id: nil, followed_id: band2.id)
    friendship.valid?
    expect(friendship.errors[:follower_id]).to include("can't be blank")
  end
  it "is invalid without followed_id" do
    friendship = Friendship.new(follower_id: band1.id, followed_id: nil)
    friendship.valid?
    expect(friendship.errors[:followed_id]).to include("can't be blank")
  end
  it "follows and unfollows a band" do
    expect(band1.following?(band2)).to be_falsey
    expect(band2.followed_by?(band1)).to be_falsey
    band1.follow(band2)
    expect(band1.following?(band2)).to be_truthy
    expect(band2.followed_by?(band1)).to be_truthy
    band1.unfollow(band2)
    expect(band1.following?(band2)).to be_falsey
    expect(band2.followed_by?(band1)).to be_falsey
  end
end
