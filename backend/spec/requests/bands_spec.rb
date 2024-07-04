require 'rails_helper'

RSpec.describe 'Bands', type: :request do
  let(:band) { create(:band) }
  let(:another_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'GET /bands/:id/edit' do
    let(:edit_path) { "/bands/#{band.id}/edit" }

    context 'when user is an account owner' do
      let(:user) { band }

      it 'responses a band data' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq band.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is another band' do
      let(:user) { another_band }

      it 'responses 403 "Forbidden"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 403 "Forbidden"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 403 "Forbidden"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 403
      end
    end
  end

  describe 'GET /bands/:id/tickets' do
    let(:tickets_path) { "/bands/#{band.id}/tickets" }

    context 'when user is an account owner' do
      let(:user) { band }

      it 'responses own tickets data' do
        event_1 = create(:event, owner: band)
        event_2 = create(:event, owner: band)
        event_3 = create(:event, owner: band)
        lineup_1 = create(:lineup, event: event_1, performer: band)
        lineup_2 = create(:lineup, event: event_2, performer: band)
        create(:lineup, event: event_3, performer: another_band)
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        expect(json[0]['id']).to eq event_1.id
        expect(json[1]['id']).to eq event_2.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is another band' do
      let(:user) { another_band }

      it 'responses 403 "Forbidden"' do
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 403 "Forbidden"' do
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 403 "Forbidden"' do
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 403
      end
    end
  end
end
