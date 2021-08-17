require 'rails_helper'

RSpec.describe Lineup, type: :model do
  let(:band) { FactoryBot.create(:band) }
  let(:event) { FactoryBot.create(:event, owner: band) }

  it "is valid with event_id and performer_id" do
    lineup = FactoryBot.build(:lineup, event: event, performer: band)
    expect(lineup).to be_valid
  end
  it "is invalid without event_id" do
    lineup = FactoryBot.build(:lineup, event: nil)
    lineup.valid?
    expect(lineup.errors[:event]).to include("must exist")
  end
  it "is invalid without performer_id" do
    lineup = FactoryBot.build(:lineup, performer: nil)
    lineup.valid?
    expect(lineup.errors[:performer]).to include("must exist")
  end
  it "is invalid with a duplicate combination of event_id and performer_id" do
    FactoryBot.create(:lineup, event: event, performer: band)
    lineup = FactoryBot.build(:lineup, event: event, performer: band)
    lineup.valid?
    expect(lineup.errors[:event]).to include("has already been taken")
  end
end
