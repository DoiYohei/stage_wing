require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:audience) { create(:audience) }
  let(:band) { create(:band) }
  let(:event) { create(:event, owner: band) }

  describe "a new record" do
    context "with an audience_id, event_id, band_id" do
      let(:ticket) { build(:ticket, audience_id: audience.id, event_id: event.id, band_id: band.id) }
      it "is valid" do
        expect(ticket).to be_valid
      end
    end
    context "without an audience_id" do
      let(:ticket) { build(:ticket, audience_id: nil, event_id: event.id, band_id: band.id) }
      it "is invalid" do
        ticket.valid?
        expect(ticket.errors[:audience]).to include("must exist")
      end
    end
    context "without an event_id" do
      let(:ticket) { build(:ticket, audience_id: audience.id, event_id: nil, band_id: band.id) }
      it "is invalid" do
        ticket.valid?
        expect(ticket.errors[:event]).to include("must exist")
      end
    end
    context "without an band_id" do
      let(:ticket) { build(:ticket, audience_id: audience.id, event_id: event.id, band_id: nil) }
      it "is invalid" do
        ticket.valid?
        expect(ticket.errors[:band]).to include("must exist")
      end
    end
    context "with a duplicate combination of audience_id, event_id and band_id" do
      before do
        create(:ticket, audience: audience, event: event, band: band)
      end
      let(:ticket) { build(:ticket, audience: audience, event: event, band: band) }
      it "is invalid" do
        ticket.valid?
        expect(ticket.errors[:audience_id]).to include("has already been taken")
      end
    end
  end
end
