require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:post) { create(:post, band: band) }
  subject { build(:like, post: post, **params) }
  describe "include UserValidator" do
    context "when both :band and :audience are present" do
      let(:params) { { band: band, audience: audience } }
      it { is_expected.to be_invalid }
    end
    context "when :band is present and :audience is not present" do
      let(:params) { { band: band, audience: nil } }
      it { is_expected.to be_valid }
    end
    context "when :band is not present and :audience is present" do
      let(:params) { { band: nil, audience: audience } }
      it { is_expected.to be_valid }
    end
    context "when both :band and :audience are not present" do
      let(:params) { { band: nil, audience: nil } }
      it { is_expected.to be_invalid }
    end
  end

  describe "validation" do
    describe "combination of :post, :band and :audience" do
      let(:params) { { band: band, audience: nil } }
      context "when duplicated" do
        before { create(:like, post: post, band: band, audience: nil) }
        it { is_expected.to be_invalid }
      end
    end
  end
end
