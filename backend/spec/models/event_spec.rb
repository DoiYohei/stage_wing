require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validation" do
    let(:band) { create(:band) }
    subject(:event) { build(:event, owner: band, **params) }
    describe ":name" do
      context "when present" do
        let(:params) { { name: "test" } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { name: nil } }
        it { is_expected.to be_invalid }
      end
    end
    describe ":place" do
      context "when present" do
        let(:params) { { place: "test" } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { place: nil } }
        it { is_expected.to be_invalid }
      end
    end
    describe ":open_at" do
      context "when present" do
        let(:params) { { open_at: Time.now } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { open_at: nil } }
        it { is_expected.to be_invalid }
      end
    end
    describe ":start_at" do
      context "when present" do
        let(:params) { { start_at: Time.now } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { start_at: nil } }
        it { is_expected.to be_invalid }
      end
    end
    describe ":reservation" do
      context "when present" do
        let(:params) { { reservation: true } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:params) { { reservation: nil } }
        it { is_expected.to be_invalid }
      end
    end
  end
end
