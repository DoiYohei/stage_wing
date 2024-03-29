require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validation' do
    subject { build(:ticket, audience: audience, band: band, event: event) }

    let(:audience) { create(:audience) }
    let(:band) { create(:band) }
    let(:event) { create(:event, owner: band) }

    describe 'combination of :audience, :band and :event' do
      context 'when unique' do
        it { is_expected.to be_valid }
      end

      context 'when duplicated' do
        before { create(:ticket, audience: audience, band: band, event: event) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
