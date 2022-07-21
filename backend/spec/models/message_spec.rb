require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validation' do
    context ':content' do
      it { is_expected.to validate_presence_of :content }
      it { is_expected.to validate_length_of(:content).is_at_most(1000) }
    end
  end

  describe '#broadcast_message' do
    let(:band) { create(:band) }
    let(:room) { create(:room) }

    context 'after_create_commit' do
      let(:message) { create(:message, band: band, room: room) }

      it "enqueues 'MessageBroadcastJob'" do
        expect { message }.to have_enqueued_job(MessageBroadcastJob)
      end
    end
  end
end
