require 'rails_helper'

RSpec.describe 'Tickets', type: :request do
  let(:band) { create(:band) }
  let(:event) { create(:event, owner: band) }
  let(:ticket_owner) { create(:audience) }
  let(:ticket) { create(:ticket, audience: ticket_owner, band: band, event: event) }

  describe 'DELETE /tickets/:id' do
    subject(:status) do
      delete "/tickets/#{ticket.id}", headers: token
      response.status
    end

    context 'when user is ticket owner' do
      let(:token) { ticket_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't ticket owner" do
      let(:token) do
        other_audience = create(:audience)
        other_audience.create_new_auth_token
      end

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
