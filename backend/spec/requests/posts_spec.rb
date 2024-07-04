require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:band) { create(:band) }
  let(:another_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'POST /posts' do
    let(:params) { { post: attributes_for(:post, :news_post) } }

    context 'when user is a login band' do
      let(:user) { band }

      it 'creates a new Post record' do
        expect { post '/posts', headers: token, params: params }.to change(Post, :count).by(1)
        expect(response.status).to eq 201
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { post '/posts', headers: token, params: params }.to change(Post, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { post '/posts', headers: token, params: params }.to change(Post, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /posts/:id' do
    let!(:post) { create(:post, :news_post, band: band) }
    let(:post_path) { "/posts/#{post.id}" }
    let(:params) { { post: { description: 'new_description' } } }

    context 'when user is a post owner' do
      let(:user) { band }

      context 'when post has existed' do
        it 'updates the post record' do
          expect(post.description).to eq 'test'
          patch post_path, headers: token, params: params
          expect(post.reload.description).to eq 'new_description'
          expect(response.status).to eq 200
        end
      end

      context 'when post has not existed' do
        let!(:another_post) { build_stubbed(:post, :news_post, band: band) }

        it 'responses 404 "Not Found"' do
          patch "/posts/#{another_post.id}", headers: token, params: params
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not a post owner' do
      let(:user) { another_band }

      it 'responses 404 "Not Found"' do
        expect(post.description).to eq 'test'
        patch post_path, headers: token, params: params
        expect(post.reload.description).to eq 'test'
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect(post.description).to eq 'test'
        patch post_path, headers: token, params: params
        expect(post.reload.description).to eq 'test'
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect(post.description).to eq 'test'
        patch post_path, headers: token, params: params
        expect(post.reload.description).to eq 'test'
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /posts/:id' do
    let!(:post) { create(:post, :news_post, band: band) }
    let(:post_path) { "/posts/#{post.id}" }

    context 'when user is a post owner' do
      let(:user) { band }

      context 'when post has existed' do
        it 'deletes the Post record' do
          expect { delete post_path, headers: token }.to change(Post, :count).by(-1)
          expect(response.status).to eq 200
        end
      end

      context 'when post has not existed' do
        let!(:another_post) { build_stubbed(:post, :news_post, band: band) }

        it 'responses 404 "Not Found"' do
          delete "/posts/#{another_post.id}", headers: token
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not a post owner' do
      let(:user) { another_band }

      it 'responses 404 "Not Found"' do
        expect { delete post_path, headers: token }.to change(Post, :count).by(0)
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { delete post_path, headers: token }.to change(Post, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { delete post_path, headers: token }.to change(Post, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
