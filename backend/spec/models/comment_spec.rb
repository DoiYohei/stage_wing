require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:band) { create(:band) }
  let(:event) { create(:event, owner: band) }
  it "is valid with band, event and content" do
    comment = build(:comment, band: band, event: event)
    expect(comment).to be_valid
  end
  it "is a valid reply with band, event parent and content" do
    comment = create(:comment, band: band, event: event)
    reply = build(:comment, band: band, event: event, parent: comment)
    expect(reply).to be_valid
  end
  it "is invalid without band" do
    comment = build(:comment, band: nil, event: event)
    comment.valid?
    expect(comment.errors[:band]).to include("must exist")  
  end
  it "is invalid without event" do
    comment = build(:comment, band: band, event: nil)
    comment.valid?
    expect(comment.errors[:event]).to include("must exist")  
  end
  it "is invalid without content" do
    comment = build(:comment, content: nil, band: band, event: event)
    comment.valid?
    expect(comment.errors[:content]).to include("can't be blank")  
  end
end
