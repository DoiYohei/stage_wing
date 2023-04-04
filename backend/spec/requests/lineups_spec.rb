require 'rails_helper'

RSpec.describe 'Lineups', type: :request do
  let(:event_owner) { create(:band) }
  let(:other_band) { create(:band) }
  let(:event) { create(:event, owner: event_owner) }

  describe 'POST /events/:id/lineups' do
    subject(:status) do
      post "/events/#{event.id}/lineups", headers: token,
                                          params: { lineup: { event_id: event.id, performer_id: other_band.id } }
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 201 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it { is_expected.to eq 403 }
    end
  end

  describe 'DELETE /events/:id/lineups' do
    subject(:status) do
      create(:lineup, event: event, performer: event_owner)
      delete "/events/#{event.id}/lineups", headers: token,
                                            params: { lineup: { event_id: event.id, performer_id: event_owner.id } }
      response.status
    end

    context 'when user is event owner' do
      let(:token) { event_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:token) { other_band.create_new_auth_token }

      it { is_expected.to eq 403 }
    end
  end
end
