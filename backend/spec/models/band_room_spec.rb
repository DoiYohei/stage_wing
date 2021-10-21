require 'rails_helper'

RSpec.describe BandRoom, type: :model do
  let(:band) { create(:band) }
  let(:room) { create(:room) }

  it "is valid with a band_id and room_id" do
    band_room = build(:band_room, band_id: band.id, room_id: room.id)
    expect(band_room).to be_valid
  end
  it "is invalid without a band_id" do
    band_room = build(:band_room, band_id: nil, room_id: room.id)
    band_room.valid?
    expect(band_room.errors[:band]).to include("can't be blank")
  end
  it "is invalid without a room_id" do
    band_room = build(:band_room, band_id: band.id, room_id: nil)
    band_room.valid?
    expect(band_room.errors[:room]).to include("can't be blank")
  end
  it "is invalid with a duplicate combination of band_id and room_id" do
    create(:band_room, band_id: band.id, room_id: room.id)
    band_room = build(:band_room, band_id: band.id, room_id: room.id)
    band_room.valid?
    expect(band_room.errors[:room_id]).to include("has already been taken")
  end
end
