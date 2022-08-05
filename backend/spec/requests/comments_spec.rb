require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:comment_owner) { create(:band) }
  let(:other_band) { create(:band) }
  let(:event) { create(:event, owner: comment_owner) }
  let(:comment) { create(:comment, event: event, band: comment_owner) }

  describe 'DELETE /comments/:id' do
    subject(:status) do
      delete "/comments/#{comment.id}", headers: token
      response.status
    end

    context 'when user is comment owner' do
      let(:token) { comment_owner.create_new_auth_token }

      it { is_expected.to eq 200 }
    end

    context "when user isn't comment owner" do
      let(:token) do
        other_band = create(:band)
        other_band.create_new_auth_token
      end

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
