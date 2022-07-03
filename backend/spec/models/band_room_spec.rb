require 'rails_helper'

RSpec.describe BandRoom, type: :model do
  describe "validation" do
    let(:band) { create(:band) }
    let(:room) { create(:room) }
    subject { build(:band_room, band: band, room: room) }
    describe "combination of :band and :room" do
      context "when unique" do
        it { is_expected.to be_valid }
      end
      context "when duplicated" do
        before { create(:band_room, band: band, room: room) }
        it { is_expected.to be_invalid }
      end
    end
  end
end
