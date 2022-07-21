require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:band) { create(:band) }
  let(:test_post) { create(:post, band: band) }
  let(:non_existent_post) { build(:post, band: band) }
  let(:token) { band.create_new_auth_token }

  describe 'POST /likes' do
    subject(:status) do
      post '/likes', headers: token, params: post_id
      response.status
    end

    context "when post has existed and user hasn't liked post" do
      let(:post_id) { { post_id: test_post.id } }

      it { is_expected.to eq 201 }
    end

    context "when post hasn't existed" do
      let(:post_id) { { post_id: non_existent_post.id } }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when user has liked post' do
      let(:post_id) { { post_id: test_post.id } }

      before { create(:like, band: band, post: test_post) }

      it { is_expected.to eq 400 }
    end
  end

  describe 'DELETE /likes/:id' do
    subject(:status) do
      create(:like, band: owner, post: test_post)
      delete '/likes', headers: token, params: { post_id: test_post.id }
      response.status
    end

    context 'when user is like owner' do
      let(:owner) { band }

      it { is_expected.to eq 200 }
    end

    context "when user isn't like owner" do
      let(:owner) { create(:band) }

      it "raises error 'ActiveRecord::RecordNotFound'" do
        expect { status }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
