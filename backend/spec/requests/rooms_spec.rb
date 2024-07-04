require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let(:band) { create(:band) }
  let(:friend) { create(:band) }
  let(:invitee) { create(:band) }
  let(:inviter) { create(:band) }
  let(:not_friend) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }
  before do
    band.follow(friend)
    friend.follow(band)
    invitee.follow(band)
    band.follow(inviter)
  end

  describe 'GET /bands/:id/rooms' do
    let(:rooms_path) { "/bands/#{band.id}/rooms" }

    context 'when user is an account owner' do
      let(:user) { band }

      it 'responses own rooms of friends' do
        another_friend = create(:band)
        band.follow(another_friend)
        another_friend.follow(band)
        friend.follow(another_friend)
        another_friend.follow(friend)
        room_1 = create(:room)
        room_2 = create(:room)
        room_3 = create(:room)
        create(:band_room, band: band, room: room_1)
        create(:band_room, band: friend, room: room_1)
        create(:band_room, band: band, room: room_2)
        create(:band_room, band: another_friend, room: room_2)
        create(:band_room, band: friend, room: room_3)
        create(:band_room, band: another_friend, room: room_3)
        get rooms_path, headers: token
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        expect(json[0]['id']).to eq room_1.id
        expect(json[0]['friend_id']).to eq friend.id
        expect(json[1]['id']).to eq room_2.id
        expect(json[1]['friend_id']).to eq another_friend.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is not an account owner' do
      let(:user) { friend }

      it 'responses 403 "Forbidden"' do
        get rooms_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        get rooms_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        get rooms_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /rooms' do
    let(:params) { { band_room: { band_id: target_band.id } } }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when target band is not a friend' do
        let(:target_band) { not_friend }

        it 'responses 403 "Forbidden"' do
          expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
          expect(response.status).to eq 403
        end
      end

      context 'when target band is an invitee' do
        let(:target_band) { invitee }

        it 'responses 403 "Forbidden"' do
          expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
          expect(response.status).to eq 403
        end
      end

      context 'when target band is an inviter' do
        let(:target_band) { inviter }

        it 'responses 403 "Forbidden"' do
          expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
          expect(response.status).to eq 403
        end
      end

      context 'when target band is a friend' do
        let(:target_band) { friend }

        context 'when user has had a room with the friend' do
          let(:room) { create(:room) }
          before do
            create(:band_room, band: band, room: room)
            create(:band_room, band: friend, room: room)
          end

          it 'responses 422 "Unprocessable Entity"' do
            expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
            expect(response.status).to eq 422
          end
        end

        context 'when user has not had a room with the friend' do
          it 'creates a new room and band_room and responses its room id' do
            expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(1)
            room_id = JSON.parse(response.body)
            expect(band.rooms.exists?(room_id)).to eq true
            expect(friend.rooms.exists?(room_id)).to eq true
            expect(response.status).to eq 201
          end
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }
      let(:target_band) { friend }

      it 'responses 401 "Unauthorized"' do
        expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }
      let(:target_band) { friend }

      it 'responses 401 "Unauthorized"' do
        expect { post '/rooms', headers: token, params: params }.to change { Room.count }.by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
