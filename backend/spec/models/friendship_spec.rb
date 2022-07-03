require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe "validation" do
    let(:band1) { create(:band) }
    let(:band2) { create(:band) }
    subject { build(:friendship, follower: band1, followed: band2) }
    describe "combination of :follower and :followed" do
      context "when unique" do
        it { is_expected.to be_valid }
      end
      context "when duplicated" do
        before { band1.follow(band2) }
        it { is_expected.to be_invalid }
      end
    end
  end
end
