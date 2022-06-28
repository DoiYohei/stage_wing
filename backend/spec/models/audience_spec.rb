require 'rails_helper'

RSpec.describe Audience, type: :model do
  describe "validation" do
    subject(:audience) { build(:audience, **name) }
    describe ":name" do
      context "when present" do
        let(:name) { { name: "test" } }
        it { is_expected.to be_valid }
      end
      context "when not present" do
        let(:name) { { name: nil } }
        it { is_expected.to be_invalid}
      end
    end
  end
end
