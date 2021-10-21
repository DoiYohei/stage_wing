require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:band) { create(:band) }
  let(:room) { create(:room) }

  describe "subscribe" do
    context "with a room_id" do
      before { subscribe(room: room.id) }
      it "is successful" do
        expect(subscription).to be_confirmed
      end
    end
    context "without a room_id" do
      before { subscribe(room: nil) }
      it "is rejected" do
        expect(subscription).to be_rejected
      end
    end
  end

  describe "a message sent by a client" do
    before do
      stub_connection(current_band: band)
      subscribe(room: room.id)
    end
    context "with a content" do
      let(:message) { build(:message) }
      it "is saved in the messages table" do
        expect {
          perform(:speak, { message: message.content })
        }.to change(Message, :count).by(1)
      end
      it "is broadcast to the connected channel" do
        expect {
          perform_enqueued_jobs do
            perform(:speak, { message: message.content })
          end
        }.to have_broadcasted_to("room_channel_#{room.id}").with{ |data|
          expect(data["content"]).to eq("MyText")
          expect(data["created_at"]).to_not eq(nil)
          expect(data["band_id"]).to eq(band.id)
        }
      end
    end
    context "without a content" do
      let(:message) { build(:message, content: nil) }
      it "isn't saved in the messages table" do
        expect {
          perform(:speak, { message: message.content })
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
