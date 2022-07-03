require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validation" do
    context ":content" do
      it { is_expected.to validate_presence_of :content}
      it { is_expected.to validate_length_of(:content).is_at_most(1000) }
    end
  end
  
  describe "include UserValidator" do
    let(:band) { create(:band) }
    let(:audience) { create(:audience) }
    let(:event) { create(:event, owner: band) }
    subject { build(:comment, event: event, **params) }
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
end
