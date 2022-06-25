require 'rails_helper'

RSpec.describe Audience, type: :model do
  describe "validation" do
    let(:audience) { build(:audience) }
    subject { audience }
    describe ":name" do
      context "when present" do
        before { audience.name = "test" }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        before { audience.name = nil }
        it { is_expected.to be_invalid}
      end
    end
  end
end
