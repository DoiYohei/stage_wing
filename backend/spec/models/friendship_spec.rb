require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'validation' do
    subject { build(:friendship, follower: band, followed: other_band) }

    let(:band) { create(:band) }
    let(:other_band) { create(:band) }

    describe 'combination of :follower and :followed' do
      context 'when unique' do
        it { is_expected.to be_valid }
      end

      context 'when duplicated' do
        before { band.follow(other_band) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
