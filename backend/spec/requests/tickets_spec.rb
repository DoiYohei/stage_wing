require 'rails_helper'

RSpec.describe 'Tickets', type: :request do
  let(:audience) { create(:audience) }
  let(:band) { create(:band) }
  let(:event) { create(:event, owner: band) }
  let(:token) { user ? user.create_new_auth_token : nil}

  describe 'POST /tickets' do
    let(:params) { { ticket: { event_id: event.id, band_id: band.id } } }

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'creates a new Ticket record' do
        expect { post '/tickets', params: params, headers: token }.to change(Ticket, :count).by(1)
        expect(response.status).to eq 201
      end
    end

    context 'when user is a login band' do
      let(:user) { band }

      it 'responses 401 "Unauthorized"' do
        expect { post '/tickets', params: params, headers: token }.to change(Ticket, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { post '/tickets', params: params, headers: token }.to change(Ticket, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /tickets/:id' do
    let!(:ticket) { create(:ticket, audience: audience, band: band, event: event) }
    let(:tickt_path) { "/tickets/#{ticket.id}" }

    context 'when user is a ticket owner' do
      let(:user) { audience }

      it 'deletes the Ticket record' do
        expect { delete tickt_path, headers: token }.to change(Ticket, :count).by(-1)
        expect(response.status).to eq 200
      end
    end

    context 'when user is not a ticket owner' do
      let(:user) { create(:audience) }

      it 'responses 404 "Not Found"' do
        expect { delete tickt_path, headers: token }.to change(Ticket, :count).by(0)
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login band' do
      let(:user) { band }

      it 'responses 401 "Unauthorized"' do
        expect { delete tickt_path, headers: token }.to change(Ticket, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { delete tickt_path, headers: token }.to change(Ticket, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
