require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:band) { create(:band) }
  let(:friend) { create(:band) }
  let(:room) { create(:room) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'GET /rooms/:id/messages' do
    let(:messages_path) { "/rooms/#{room.id}/messages" }
    let(:params) { { band_id: friend.id } }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when user is not a member of the room' do
        it 'responses 404 "Not Found"' do
          get messages_path, headers: token, params: params
          json = JSON.parse(response.body)
          expect(json[0]).to eq nil
          expect(response.status).to eq 404
        end
      end

      context 'when user is a member of the room' do
        before do
          band.follow(friend)
          friend.follow(band)
          create(:band_room, band: band, room: room)
          create(:band_room, band: friend, room: room)
        end

        it 'responses messages of the room' do
          another_friend = create(:band)
          another_room = create(:room)
          band.follow(another_friend)
          another_friend.follow(band)
          create(:band_room, band: band, room: another_room)
          create(:band_room, band: another_friend, room: another_room)
          message_1 = create(:message, room: room, band: band)
          message_2 = create(:message, room: room, band: friend)
          message_3 = create(:message, room: another_room, band: band)
          message_4 = create(:message, room: another_room, band: another_friend)
          get messages_path, headers: token, params: params
          json = JSON.parse(response.body)
          expect(json.length).to eq 2
          expect(json['messages'][0]['id']).to eq message_1.id
          expect(json['messages'][1]['id']).to eq message_2.id
          expect(json['partner']['id']).to eq friend.id
          expect(response.status).to eq 200
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { create(:audience) }

      it 'responses 401 "Unauthorized"' do
        get messages_path, headers: token, params: params
        json = JSON.parse(response.body)
        expect(json['messages']).to eq nil
        expect(json['partner']).to eq nil
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        get messages_path, headers: token, params: params
        json = JSON.parse(response.body)
        expect(json['messages']).to eq nil
        expect(json['partner']).to eq nil
        expect(response.status).to eq 401
      end
    end
  end
end
