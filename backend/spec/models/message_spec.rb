require 'rails_helper'

RSpec.describe Message, type: :model do

  let(:band) { create(:band) }
  let(:room) { create(:room) }

  describe "a new record" do
    context "with a band_id, room_id, and content" do
      let(:message) { build(:message, band_id: band.id, room_id: room.id) }
      it "is valid" do
        expect(message).to be_valid
      end
    end
    context "without a band_id" do
      let(:message) { build(:message, band_id: nil, room_id: room.id) }
      it "is invalid" do
        message.valid?
        expect(message.errors[:band]).to include("can't be blank")  
      end
    end
    context "without a room_id" do
      let(:message) { build(:message, band_id: band.id, room_id: nil) }
      it "is invalid" do
        message.valid?
        expect(message.errors[:room]).to include("can't be blank")  
      end
    end
    context "without a content" do
      let(:message) { build(:message, band_id: band.id, room_id: room.id, content: nil) }
      it "is invalid" do
        message.valid?
        expect(message.errors[:content]).to include("can't be blank")  
      end
    end
  end

  describe "#broadcast_message" do
    context "after_create_commit" do
      let(:message) { create(:message, band: band, room: room) }
      it "enqueues 'MessageBroadcastJob'" do
        expect { message }.to have_enqueued_job(MessageBroadcastJob)
      end
    end
  end
end
