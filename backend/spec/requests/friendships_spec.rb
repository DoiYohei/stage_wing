require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let(:band) { create(:band) }
  let(:other_band) { create(:band) }
  let(:non_existent_band) { build(:band) }
  let(:token) { band.create_new_auth_token }

  describe 'POST /friendships' do
    subject(:status) do
      post '/friendships', headers: token, params: followed_id
      response.status
    end

    context "when band hasn't followed other_band" do
      let(:followed_id) { { followed_id: other_band.id } }

      it { is_expected.to eq 201 }
    end

    context 'when band has followed other_band' do
      before { band.follow(other_band) }

      let(:followed_id) { { followed_id: other_band.id } }

      it { is_expected.to eq 400 }
    end

    context "when followed band hasn't existed" do
      let(:followed_id) { { followed_id: non_existent_band.id } }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /friendships' do
    subject do
      delete '/friendships', headers: token, params: { followed_id: other_band.id }
      response.status
    end

    context 'when band has followed other_band' do
      before { band.follow(other_band) }

      it { is_expected.to eq 200 }
    end

    context "when band hasn't followed other_band" do
      it { is_expected.to eq 400 }
    end
  end
end
