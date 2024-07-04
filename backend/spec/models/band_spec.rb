require 'rails_helper'

RSpec.describe Band, type: :model do
  describe 'validation' do
    describe ':email' do
      context 'when correct format' do
        let(:band1) { build(:band, email: 'test1@example.com') }
        let(:band2) { build(:band, email: 'T.e_s-t@example.com') }
        let(:band3) { build(:band, email: 'test@example.ne.jp') }

        it 'is valid' do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end

      context 'when incorrect format' do
        let(:band1) { build(:band, email: 'test@example') }
        let(:band2) { build(:band, email: 'test@example.ne-jp') }
        let(:band3) { build(:band, email: 'test.com') }

        it 'is invalid' do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end

    describe ':website' do
      context 'when correct format' do
        let(:band1) { build(:band, website: 'http://example1.com') }
        let(:band2) { build(:band, website: 'http://www.example.com') }
        let(:band3) { build(:band, website: "http://example@#&*()-_+~:;',?=test.com") }

        it 'is valid' do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end

      context 'when incorrect format' do
        let(:band1) { build(:band, website: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, website: 'http://example.com/?<script>alert(document.domain);</script>') }
        let(:band3) { build(:band, website: 'http://example.com/"onmouseover="alert(1)"') }

        it 'is invalid' do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end

    describe ':twitter' do
      context 'when correct format' do
        let(:band1) { build(:band, twitter: 'http://example1.com') }
        let(:band2) { build(:band, twitter: 'http://www.example.com') }
        let(:band3) { build(:band, twitter: "http://example@#&*()-_+~:;',?=test.com") }

        it 'is valid' do
          expect(band1).to be_valid
          expect(band2).to be_valid
          expect(band3).to be_valid
        end
      end

      context 'when incorrect format' do
        let(:band1) { build(:band, twitter: "javascript:alert('XSS');//http://example.com") }
        let(:band2) { build(:band, twitter: 'http://example.com/?<script>alert(document.domain);</script>') }
        let(:band3) { build(:band, twitter: 'http://example.com/"onmouseover="alert(1)"') }

        it 'is invalid' do
          expect(band1).to be_invalid
          expect(band2).to be_invalid
          expect(band3).to be_invalid
        end
      end
    end
  end

  describe 'methods of Friendship related' do
    let(:band) { create(:band) }
    let(:another_band) { create(:band) }

    describe '#follow' do
      context 'band has not followed another band' do
        it 'creates a new active_friendship with another band' do
          expect(band.active_friendships).to be_empty
          band.follow(another_band)
          expect(band.active_friendships.size).to eq 1
          expect(band.active_friendships[0].followed).to eq another_band
        end
      end

      context 'band has followed another band' do
        before { band.follow(another_band) }

        it 'raises ActiveRecord::RecordInvalid' do
          expect { band.follow(another_band) }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
    describe 'unfollow' do
      context 'band has followed another band' do
        before { band.follow(another_band) }

        it 'destroys the active_friendship with another band' do
          expect(band.active_friendships.size).to eq 1
          band.unfollow(another_band)
          expect(band.active_friendships).to be_empty
        end
      end

      context 'two bands have followed each other and have the room' do
        before do
          band.follow(another_band)
          another_band.follow(band)
          room = create(:room)
          create(:band_room, band: band, room: room)
          create(:band_room, band: another_band, room: room)
        end

        it 'destroys the room and the band_rooms of two bands and the active_friendship of the band with another band' do
          expect(band.active_friendships[0].followed).to eq another_band
          expect(band.rooms.size).to eq 1
          expect(another_band.active_friendships[0].followed).to eq band
          expect(another_band.rooms.size).to eq 1
          band.unfollow(another_band)
          band.reload
          another_band.reload
          expect(band.active_friendships).to be_empty
          expect(band.rooms).to be_empty
          expect(another_band.active_friendships[0].followed).to eq band
          expect(another_band.rooms).to be_empty
        end
      end

      context 'band has not followed another band' do
        it 'does nothing' do
          expect(band.active_friendships).to be_empty
          band.unfollow(another_band)
          expect(band.active_friendships).to be_empty
        end
      end
    end

    describe '#following?' do
      context 'band has followed another band' do
        before { band.follow(another_band) }

        it 'returns true' do
          expect(band.following?(another_band)).to be_truthy
        end
      end

      context 'band has not followed another band' do
        it 'returns false' do
          expect(band.following?(another_band)).to be_falsy
        end
      end
    end

    describe '#friends' do
      context 'when two bands have followed each other' do
        before do
          band.follow(another_band)
          another_band.follow(band)
        end

        it 'includes each other' do
          expect(band.friends).to include another_band
          expect(another_band.friends).to include band
          expect(band.invitees).not_to include another_band
          expect(another_band.invitees).not_to include band
          expect(band.inviters).not_to include another_band
          expect(another_band.inviters).not_to include band
        end
      end
    end

    describe '#invitees' do
      context 'when band has followed another band, but another band has not followed band' do
        before { band.follow(another_band) }

        it 'includes another band' do
          expect(band.invitees).to include another_band
          expect(band.friends).to be_empty
          expect(band.inviters).to be_empty
        end
      end

      context 'when band has not followed another band' do
        it 'is empty' do
          expect(band.invitees).to be_empty
          expect(band.friends).to be_empty
          expect(band.inviters).to be_empty
        end
      end
    end

    describe '#inviters' do
      context 'when band has been followed by another band, but band has not followed another band' do
        before { another_band.follow(band) }

        it 'includes another band' do
          expect(band.inviters).to include another_band
          expect(band.invitees).to be_empty
          expect(band.friends).to be_empty
        end
      end
    end

    describe '#friend_state' do
      subject { band.friend_state(another_band) }

      context 'when two bands have followed each other' do
        before do
          band.follow(another_band)
          another_band.follow(band)
        end

        it { is_expected.to eq 'friend' }
      end

      context 'when band has followed another band, but another band has not followed band' do
        before { band.follow(another_band) }

        it { is_expected.to eq 'inviting' }
      end

      context "when another band has followed band, but band has not followed another band" do
        before { another_band.follow(band) }

        it { is_expected.to eq 'invited' }
      end

      context 'when two bands have not followed each other' do
        it { is_expected.to be_nil }
      end
    end
  end

  describe 'methods of Room related' do
    let(:band) { create(:band) }
    let(:another_band) { create(:band) }

    describe '#fetch_rooms' do
      let(:first_room) { band.fetch_rooms[0] }

      context 'when two bands have followed each other' do
        before do
          band.follow(another_band)
          another_band.follow(band)
        end

        context 'when room has not created' do
          it 'has another band params and does not have room_id' do
            expect(first_room[:id]).to be_nil
            expect(first_room[:friend_id]).to eq(another_band.id)
            expect(first_room[:friend_name]).to eq(another_band.name)
            expect(first_room[:friend_img]).to eq(another_band.image.url)
          end
        end

        context 'when room has created' do
          let(:room) { create(:room) }
          before do
            create(:band_room, band: band, room: room)
            create(:band_room, band: another_band, room: room)
          end

          it 'has room_id and another band params' do
            expect(first_room[:id]).to eq(room.id)
            expect(first_room[:friend_id]).to eq(another_band.id)
            expect(first_room[:friend_name]).to eq(another_band.name)
            expect(first_room[:friend_img]).to eq(another_band.image.url)
          end
        end
      end

      shared_examples 'fetch_rooms of band is empty' do
        it 'is empty' do
          expect(band.fetch_rooms).to be_empty
        end
      end

      context 'when band has followed another band, but another band has not followed band' do
        before { band.follow(another_band) }

        it_behaves_like 'fetch_rooms of band is empty'
      end

      context 'when another band has followed band, but band has not followed another band' do
        before { another_band.follow(band) }

        it_behaves_like 'fetch_rooms of band is empty'
      end

      context 'when two bands have not followed each other' do
        it_behaves_like 'fetch_rooms of band is empty'
      end
    end

    describe '#has_room_with?' do
      before do
        band.follow(another_band)
        another_band.follow(band)
      end

      context 'when two bands have had a room with each other' do
        let(:room) { create(:room) }
        before do
          create(:band_room, band: band, room: room)
          create(:band_room, band: another_band, room: room)
        end

        it 'returns true' do
          expect(band.has_room_with?(another_band)).to be_truthy
        end
      end
      context 'when two bands have not had a room with each other' do
        it 'returns false' do
          expect(band.has_room_with?(another_band)).to be_falsy
        end
      end
    end

    describe '#create_room_with' do
      it 'creates a new room and band_rooms with another band' do
        expect(band.rooms).to be_empty
        expect(another_band.rooms).to be_empty
        band.create_room_with(another_band)
        expect(band.rooms.size).to eq 1
        expect(another_band.rooms.size).to eq 1
        expect(band.has_room_with?(another_band)).to be_truthy
        expect(another_band.has_room_with?(band)).to be_truthy
      end
    end

    describe '#destroy_room_with' do
      before do
        band.follow(another_band)
        another_band.follow(band)
      end

      context 'when two bands have had a room with each other' do
        let(:room) { create(:room) }
        before do
          create(:band_room, band: band, room: room)
          create(:band_room, band: another_band, room: room)
        end

        it 'destroys the room and the band_rooms of two bands' do
          expect(band.rooms.size).to eq 1
          expect(another_band.rooms.size).to eq 1
          band.destroy_room_with(another_band)
          band.reload
          another_band.reload
          expect(band.rooms).to be_empty
          expect(another_band.rooms).to be_empty
        end
      end

      context 'when two bands have not had a room with each other' do
        it 'does nothing' do
          expect(band.rooms).to be_empty
          expect(another_band.rooms).to be_empty
          band.destroy_room_with(another_band)
          expect(band.rooms).to be_empty
          expect(another_band.rooms).to be_empty
        end
      end
    end
  end
end
