require 'rails_helper'

RSpec.describe Band, type: :model do
  describe "validation" do
    describe ":email" do
      context "when correct format" do
        let(:band1) { build(:band, email: "test1@example.com") }
        let(:band2) { build(:band, email: "T.e_s-t@example.com") }
        let(:band3) { build(:band, email: "test@example.ne.jp") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, email: "test@example") }
        let(:band2) { build(:band, email: "test@example.ne-jp") }
        let(:band3) { build(:band, email: "test.com") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
    describe ":website" do
      context "when correct format" do
        let(:band1) { build(:band, website: "http://example1.com") }
        let(:band2) { build(:band, website: "http://www.example.com") }
        let(:band3) { build(:band, website: "http://example@#$&*()-_+~:;',?=test.com") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, website: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, website: "http://example.com/?<script>alert(document.domain);</script>") }
        let(:band3) { build(:band, website: "http://example.com/\"onmouseover=\"alert(1)\"") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
    describe ":twitter" do
      context "when correct format" do
        let(:band1) { build(:band, twitter: "http://example1.com") }
        let(:band2) { build(:band, twitter: "http://www.example.com") }
        let(:band3) { build(:band, twitter: "http://example@#$&*()-_+~:;',?=test.com") }
        it "is valid" do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end
      context "when incorrect format" do
        let(:band1) { build(:band, twitter: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, twitter: "http://example.com/?<script>alert(document.domain);</script>") }
        let(:band3) { build(:band, twitter: "http://example.com/\"onmouseover=\"alert(1)\"") }
        it "is invalid" do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
  end

  describe "methods of Friendship related" do
    let(:band) { create(:band) }
    let(:other_band) { create(:band) }
    describe "#friends" do
      context "when two bands are following each other" do
        before {
          band.follow(other_band)
          other_band.follow(band)
        }
        it "includes each other" do
          expect(band.friends).to include other_band
          expect(other_band.friends).to include band
          expect(band.inviting).not_to include other_band
          expect(other_band.inviting).not_to include band
          expect(band.inviters).not_to include other_band
          expect(other_band.inviters).not_to include band
        end
      end
    end
    describe "#inviting, #inviters" do
      context "when band is following other_band, but other_band isn't following band" do
        before { band.follow(other_band) }
        it "is that inviting of band includes other_band" do
          expect(band.inviting).to include other_band
          expect(band.friends).not_to include other_band
          expect(band.inviters).not_to include other_band
        end
        it "is that inviters of other_band includes band" do
          expect(other_band.inviters).to include band
          expect(other_band.friends).not_to include band
          expect(other_band.inviting).not_to include band
        end
      end
    end
    describe "#friend_status" do
      subject { band.friend_status(other_band) } 
      context "when two bands are following each other" do
        before {
          band.follow(other_band)
          other_band.follow(band)
        }
        it { is_expected.to eq "friend" }
      end
      context "when band is following other_band, but other_band isn't following band" do
        before { band.follow(other_band) }
        it { is_expected.to eq "inviting" }
      end
      context "when other_band is following band, but band isn't following other_band" do
        before { other_band.follow(band) }
        it { is_expected.to eq "invited" }
      end
      context "when two bands aren't following each other" do
        it { is_expected.to eq nil }
      end
    end
  end

  describe "methods of Chat related" do
    let(:band) { create(:band) }
    let(:other_band) { create(:band) }
    describe "#fetch_rooms" do
      let(:fetch_room) { band.fetch_rooms[0] }
      let(:fetch_rooms) { band.fetch_rooms }
      context "when two bands are following each other" do
        before {
          band.follow(other_band)
          other_band.follow(band)
        }
        context "when room hasn't been created yet" do
          it "has hash of no room_id and other_band params" do
            expect(fetch_room[:id]).to eq(nil)
            expect(fetch_room[:friend_id]).to eq(other_band.id)
            expect(fetch_room[:friend_name]).to eq(other_band.name)
            expect(fetch_room[:friend_img]).to eq(other_band.image.url)
          end
        end
        context "when room has been already created" do
          let(:room) { create(:room) }
          before {
            create(:band_room, band: band, room: room)
            create(:band_room, band: other_band, room: room)
          }
          it "has hash of room_id and other_band params" do
            expect(fetch_room[:id]).to eq(room.id)
            expect(fetch_room[:friend_id]).to eq(other_band.id)
            expect(fetch_room[:friend_name]).to eq(other_band.name)
            expect(fetch_room[:friend_img]).to eq(other_band.image.url)
          end
        end
      end
      context "when band is following other_band, but other_band isn't following band" do
        before { band.follow(other_band) }
        it "is empty" do
          expect(fetch_rooms).to be_empty
        end
      end
      context "when other_band is following band, but band isn't following other_band" do
        before { other_band.follow(band) }
        it "is empty" do
          expect(fetch_rooms).to be_empty
        end
      end
      context "when two bands aren't following each other" do
        it "is empty" do
          expect(fetch_rooms).to be_empty
        end
      end
    end
  end
end
