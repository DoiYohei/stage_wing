require 'rails_helper'

RSpec.describe 'Lineups', type: :request do
  let(:band) { create(:band) }
  let(:another_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:event) { create(:event, owner: band) }
  let(:token) { user ? user.create_new_auth_token : nil}
  let(:lineup_path) { "/events/#{event.id}/lineups" }
  let(:params) { { lineup: { event_id: event.id, performer_id: band.id } } }

  describe 'POST /events/:id/lineups' do
    context 'when user is an event owner' do
      let(:user) { band }

      it 'creates a new Lineup record' do
        expect { post lineup_path, headers: token, params: params }.to change(Lineup, :count).by(1)
        expect(response.status).to eq 201
      end
    end

    context 'when user is not event owner' do
      let(:user) { another_band }

      it 'responses 403 "Forbidden"' do
        expect { post lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 403
      end
    end

    context 'when user is an audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { post lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { post lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /events/:id/lineups' do
    context 'when user is an event owner' do
      let(:user) { band }

      context 'when lineup has existed' do
        before { create(:lineup, event: event, performer: band) }

        it 'deletes the Lineup record' do
          expect { delete lineup_path, headers: token, params: params }.to change(Lineup, :count).by(-1)
          expect(response.status).to eq 200
        end
      end

      context 'when lineup has not existed' do
        it 'responses 404 "Not Found"' do
          expect { delete lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not event owner' do
      let(:user) { another_band }

      it 'responses 403 "Forbidden"' do
        expect { delete lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 403
      end
    end

    context 'when user is an audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { delete lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { delete lineup_path, headers: token, params: params }.to change(Lineup, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
