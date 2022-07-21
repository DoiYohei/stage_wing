require 'rails_helper'

RSpec.describe 'Lineups', type: :request do
  let(:event_owner) { create(:band) }
  let(:other_band) { create(:band) }
  let(:event) { create(:event, owner: event_owner) }
  let(:lineup) { create(:lineup, event: event, performer: event_owner) }

  describe 'GET /events/:id/lineups' do
    subject(:status) do
      get "/events/#{event.id}/lineups", headers: token
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /events/:id/lineups' do
    subject(:status) do
      get "/events/#{event.id}/lineups", headers: token,
                                         params: { lineup: { event_id: event.id, performer_id: other_band.id } }
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH /events/:id/lineups/:id' do
    subject(:status) do
      patch "/events/#{event.id}/lineups/#{lineup.id}", headers: token,
                                                        params: { lineup: { performer_id: other_band.id } }
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /events/:id/lineups/:id' do
    subject(:status) do
      delete "/events/#{event.id}/lineups/#{lineup.id}", headers: token
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
