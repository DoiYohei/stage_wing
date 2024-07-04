require 'rails_helper'

RSpec.describe 'Audiences', type: :request do
  let(:band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:another_audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'GET /audiences/:id/edit' do
    let(:edit_path) { "/audiences/#{audience.id}/edit" }

    context 'when user is an account owner' do
      let(:user) { audience }

      it 'responses a audience data' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq audience.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is another audience' do
      let(:user) { another_audience }

      it 'responses 403 "Forbidden"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login band' do
      let(:user) { band }

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

  describe 'GET /audiences/:id/tickets' do
    let(:tickets_path) { "/audiences/#{audience.id}/tickets" }

    context 'when user is an account owner' do
      let(:user) { audience }

      it 'responses own tickets' do
        event_1 = create(:event, owner: band)
        event_2 = create(:event, owner: band)
        ticket_1 = create(:ticket, event: event_1, band: band, audience: audience)
        ticket_2 = create(:ticket, event: event_2, band: band, audience: audience)
        create(:ticket, event: event_1, band: band, audience: another_audience)
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        expect(json[0]['ticket_id']).to eq ticket_1.id
        expect(json[1]['ticket_id']).to eq ticket_2.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is another audience' do
      let(:user) { another_audience }

      it 'responses 403 "Forbidden"' do
        get tickets_path, headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 403
      end
    end

    context 'when user is a login band' do
      let(:user) { band }

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
