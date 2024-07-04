require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let(:band) { create(:band) }
  let(:another_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'GET /bands/:id/friendships' do
    let(:friendships_path) { "/bands/#{band.id}/friendships" }

    context 'when user is an account owner' do
      let(:user) { band }

      it 'responses a friendship data' do
        extra_band = create(:band)
        band.follow(another_band)
        band.follow(extra_band)
        another_band.follow(band)
        another_band.follow(extra_band)
        get friendships_path, headers: token
        json = JSON.parse(response.body)
        expect(json['invitees'].length).to eq 1
        expect(json['invitees'][0]['id']).to eq extra_band.id
        expect(json['friends'].length).to eq 1
        expect(json['friends'][0]['id']).to eq another_band.id
        expect(json['inviters'].length).to eq 0
        expect(response.status).to eq 200
      end
    end

    context 'when user is not an account owner' do
      let(:user) { another_band }

      it 'responses 403 "Forbidden"' do
        get friendships_path, headers: token
        json = JSON.parse(response.body)
        expect(json['invitees']).to eq nil
        expect(json['friends']).to eq nil
        expect(json['inviters']).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        get friendships_path, headers: token
        json = JSON.parse(response.body)
        expect(json['invitees']).to eq nil
        expect(json['friends']).to eq nil
        expect(json['inviters']).to eq nil
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        get friendships_path, headers: token
        json = JSON.parse(response.body)
        expect(json['invitees']).to eq nil
        expect(json['friends']).to eq nil
        expect(json['inviters']).to eq nil
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /friendships' do
    let(:params) { { followed_id: followed_band.id } }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when band has not followed another_band' do
        let(:followed_band) { another_band }

        it 'creates a new friendship' do
          expect { post '/friendships', headers: token, params: params }.to change(Friendship, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context 'when band has followed another_band' do
        before { band.follow(another_band) }
        let(:followed_band) { another_band }

        it 'responses 400 "Bad Request"' do
          expect { post '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
          expect(response.status).to eq 400
        end
      end

      context 'when followed band has not existed' do
        let(:non_existent_band) { build_stubbed(:band) }
        let(:followed_band) { non_existent_band }

        it 'responses 404 "Not Found"' do
          expect { post '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }
      let(:followed_band) { another_band }

      it 'responses 401 "Unauthorized"' do
        expect { post '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }
      let(:followed_band) { another_band }

      it 'responses 401 "Unauthorized"' do
        expect { post '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /friendships' do
    let(:params) { { followed_id: followed_band.id } }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when user has followed an existent band' do
        before { band.follow(another_band) }
        let(:followed_band) { another_band }

        it 'deletes the friendship' do
          expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(-1)
          expect(response.status).to eq 200
        end

        context 'if user has had a room with the followed band' do
          before { another_band.follow(band) }
          let(:room) { create(:room) }
          let(:band_room) { create(:band_room, band: band, room: room) }
          let(:friend_room) { create(:band_room, band: another_band, room: room) }

          it 'deletes the friendship, room and band_rooms' do
            expect(Room.find_by(id: room.id)).to eq room
            expect(BandRoom.find_by(id: band_room.id)).to eq band_room
            expect(BandRoom.find_by(id: friend_room.id)).to eq friend_room
            expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(-1)
            expect(response.status).to eq 200
            expect(Room.find_by(id: room.id)).to eq nil
            expect(BandRoom.find_by(id: band_room.id)).to eq nil
            expect(BandRoom.find_by(id: friend_room.id)).to eq nil
          end
        end
      end

      context 'when user has not followed an existent band' do
        let(:followed_band) { another_band }

        it 'responses 400 "Bad Request"' do
          expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
          expect(response.status).to eq 400
        end
      end

      context 'when followed band has not existed' do
        let(:followed_band) { build_stubbed(:band) }

        it 'responses 404 "Not Found"' do
          expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }
      let(:followed_band) { another_band }

      it 'responses 401 "Unauthorized"' do
        expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }
      let(:followed_band) { another_band }

      it 'responses 401 "Unauthorized"' do
        expect { delete '/friendships', headers: token, params: params }.to change(Friendship, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
