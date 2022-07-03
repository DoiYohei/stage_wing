require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:band) { create(:band) }
  let(:room) { create(:room) }

  describe "#subscribed" do
    subject { subscription }
    context "with a room_id" do
      before { subscribe(room: room.id) }
      it { is_expected.to be_confirmed }
    end
    context "without a room_id" do
      before { subscribe(room: nil) }
      it { is_expected.to be_rejected }
    end
  end

  describe "#speak" do
    before do
      stub_connection(current_band: band)
      subscribe(room: room.id)
    end
    context "when new message has a content" do
      let(:message) { build(:message, content: "test") }
      it "creates new message" do
        expect {
          perform(:speak, { message: message.content })
        }.to change(Message, :count).by(1)
      end
      it "broadcasts new message to the connected channel" do
        expect {
          perform_enqueued_jobs do
            perform(:speak, { message: message.content })
          end
        }.to have_broadcasted_to("room_channel_#{room.id}").with{ |data|
          expect(data["content"]).to eq("test")
          expect(data["created_at"]).to_not eq(nil)
          expect(data["band_id"]).to eq(band.id)
        }
      end
    end
    context "when new message hasn't a content" do
      let(:message) { build(:message, content: nil) }
      it "dosen't creat and broadcact new message" do
        expect {
          perform(:speak, { message: message.content })
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
