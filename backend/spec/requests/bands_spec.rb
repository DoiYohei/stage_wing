require 'rails_helper'

RSpec.describe 'Bands', type: :request do
  let(:band) { create(:band) }
  let(:other_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'GET /bands/:id/edit' do
    subject do
      get "/bands/#{band.id}/edit", headers: token
      response.status
    end

    context 'when user is owner of band' do
      let(:user) { band }

      it { is_expected.to eq 200 }
    end

    context 'when user is owner of other_band' do
      let(:user) { other_band }

      it { is_expected.to eq 401 }
    end

    context 'when user is login audience' do
      let(:user) { audience }

      it { is_expected.to eq 401 }
    end

    context "when user isn't login member" do
      let(:user) { nil }

      it { is_expected.to eq 401 }
    end
  end

  describe 'GET /bands/:id/tickets' do
    subject do
      get "/bands/#{band.id}/tickets", headers: token
      response.status
    end

    context 'when user is owner of band' do
      let(:user) { band }

      it { is_expected.to eq 200 }
    end

    context 'when user is owner of other_band' do
      let(:user) { other_band }

      it { is_expected.to eq 401 }
    end

    context 'when user is login audience' do
      let(:user) { audience }

      it { is_expected.to eq 401 }
    end

    context "when user isn't login member" do
      let(:user) { nil }

      it { is_expected.to eq 401 }
    end
  end
end
