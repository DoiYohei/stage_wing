require 'rails_helper'

RSpec.describe Audience, type: :model do
  describe "a new record" do
    context "with a name, email, password, and image" do
      let(:audience) { build(:audience) }
      it "is valid" do
        expect(audience).to be_valid
      end
    end
    context "without a image" do
      let(:audience) { build(:audience, image: nil) }
      it "is valid" do
        expect(audience).to be_valid  
      end
    end
    context "without a name" do
      let(:audience) { build(:audience, name: nil) }
      it "is invalid" do
        audience.valid?
        expect(audience.errors[:name]).to include("can't be blank")
      end
    end
  end
end
