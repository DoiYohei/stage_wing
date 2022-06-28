require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validation" do
    let(:band) { create(:band) }
    subject(:post) { build(:post, band: band, **params) }
    describe ":format" do
      context "when present" do
        let(:params) { { format: "photo" } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { format: nil } }
        it { is_expected.to be_invalid }
      end
    end
    describe ":media_pass" do
      context "when not present" do
        let(:params) { { media_pass: nil } }
        it { is_expected.to be_valid }
      end
      context "when correct format" do
        let(:params) { { media_pass: "Test1" } }
        it { is_expected.to be_valid }
      end
      context "when incorrect format" do
        let(:params) { { media_pass: "test-1" } }
        it { is_expected.to be_invalid }
      end
    end
  end
end
