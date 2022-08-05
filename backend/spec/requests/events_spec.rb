require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:band) { create(:band) }
  let(:other_band) { create(:band) }
  let(:event) { create(:event, owner: band) }
  let(:token) { user.create_new_auth_token }

  describe 'GET /events/:id/edit' do
    subject(:status) do
      get "/events/#{event.id}/edit", headers: token
      response.status
    end

    context 'when user is event owner' do
      let(:user) { band }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:user) { other_band }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH /events/:id' do
    subject(:status) do
      patch "/events/#{event.id}", headers: token, params: { event: { name: 'updated_name' } }
      response.status
    end

    context 'when user is event owner' do
      let(:user) { band }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:user) { other_band }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /events/:id' do
    subject(:status) do
      delete "/events/#{event.id}", headers: token
      response.status
    end

    context 'when user is event owner' do
      let(:user) { band }

      it { is_expected.to eq 200 }
    end

    context "when user isn't event owner" do
      let(:user) { other_band }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
