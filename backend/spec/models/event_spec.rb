require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:band) { create(:band) }
  it "is valid with a name, flyer, place, open_at, start_at, ticket_price, content, unregistered_performers" do
    event = build(:event, owner: band)
    expect(event).to be_valid
  end
  it "is valid only with a name, place, open_at, and start_at" do
    event = build(:event, owner: band, flyer: nil, ticket_price: nil, content: nil, unregistered_performers: nil)
    expect(event).to be_valid  
  end
  it "is invalid without name" do
    event = build(:event, owner: band, name: nil)
    event.valid?
    expect(event.errors[:name]).to include("can't be blank")  
  end
  it "is invalid without place" do
    event = build(:event, owner: band, place: nil)
    event.valid?
    expect(event.errors[:place]).to include("can't be blank")  
  end
  it "is invalid without open_at" do
    event = build(:event, owner: band, open_at: nil)
    event.valid?
    expect(event.errors[:open_at]).to include("can't be blank")  
  end
  it "is invalid without start_at" do
    event = build(:event, owner: band, start_at: nil)
    event.valid?
    expect(event.errors[:start_at]).to include("can't be blank")  
  end
end
