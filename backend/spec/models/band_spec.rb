require 'rails_helper'

RSpec.describe Band, type: :model do
  it "is valid with a name, email, password, image, profile, website, and twitter" do
    expect(build(:band)).to be_valid
  end
  it "is valid only with a name, email, and password" do
    band = build(:band, image: nil, profile: nil, website: nil, twitter: nil)
    expect(band).to be_valid
  end
  it "is invalid without a name" do
    band = build(:band, name: nil)
    band.valid?
    expect(band.errors[:name]).to include("can't be blank")
  end
end
