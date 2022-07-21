require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:post_owner) { create(:band) }
  let(:other_band) { create(:band) }
  let(:post) { create(:post, band: post_owner) }
  let(:token) { user.create_new_auth_token }

  describe 'PATCH /posts/:id' do
    subject(:status) do
      patch "/posts/#{post.id}", headers: token, params: { post: { description: 'updated_description' } }
      response.status
    end

    context 'when user is post owner' do
      let(:user) { post_owner }

      it { is_expected.to eq 200 }
    end

    context "when user isn't post owner" do
      let(:user) { other_band }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /posts/:id' do
    subject(:status) do
      delete "/posts/#{post.id}", headers: token
      response.status
    end

    context 'when user is post owner' do
      let(:user) { post_owner }

      it { is_expected.to eq 200 }
    end

    context "when user isn't post owner" do
      let(:user) { other_band }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
