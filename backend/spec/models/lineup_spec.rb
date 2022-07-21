require 'rails_helper'

RSpec.describe Lineup, type: :model do
  describe 'validation' do
    subject { build(:lineup, event: event, performer: band) }

    let(:band) { create(:band) }
    let(:event) { create(:event, owner: band) }

    describe 'combination of :event and :performer' do
      context 'when unique' do
        it { is_expected.to be_valid }
      end

      context 'when duplicated' do
        before { create(:lineup, event: event, performer: band) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
