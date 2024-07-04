require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ?  user.create_new_auth_token : nil }

  describe 'GET /likes' do
    let(:another_band) { create(:band) }
    let(:another_audience) { create(:audience) }
    let(:post_1) { create(:post, band: band) }
    let(:post_2) { create(:post, band: band) }
    let(:post_3) { create(:post, band: band) }
    before do
      create(:like, band: band, audience: nil, post: post_1)
      create(:like, band: band, audience: nil, post: post_2)
      create(:like, band: another_band, audience: nil, post: post_3)
      create(:like, band: nil, audience: audience, post: post_2)
      create(:like, band: nil, audience: another_audience, post: post_1)
    end

    context 'when user is a band' do
      let(:user) { band }

      it 'responses liked posts' do
        get '/likes', headers: token
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        expect(json[0]['id']).to eq post_2.id
        expect(json[1]['id']).to eq post_1.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is an audience' do
      let(:user) { audience }

      it 'responses liked posts' do
        get '/likes', headers: token
        json = JSON.parse(response.body)
        expect(json.length).to eq 1
        expect(json[0]['id']).to eq post_2.id
        expect(response.status).to eq 200
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        get '/likes', headers: token
        json = JSON.parse(response.body)
        expect(json[0]).to eq nil
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /likes' do
    let(:params) { { post_id: band_post.id } }
    let(:existent_post) { create(:post, band: band) }
    let(:non_existent_post) { build_stubbed(:post, band: band) }

    context 'when user is a band' do
      let(:user) { band }

      context 'when post has existed' do
        let(:band_post) { existent_post }

        it 'creates a new Like record' do
          expect { post '/likes', headers: token, params: params }.to change(Like, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context 'when post has not existed' do
        let(:band_post) { non_existent_post }

        it 'responses 404 "Not Found"' do
          expect { post '/likes', headers: token, params: params }.to change(Like, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is an audience' do
      let(:user) { audience }

      context 'when post has existed' do
        let(:band_post) { existent_post }

        it 'creates a new Like record' do
          expect { post '/likes', headers: token, params: params }.to change(Like, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context 'when post has not existed' do
        let(:band_post) { non_existent_post }

        it 'responses 404 "Not Found"' do
          expect { post '/likes', headers: token, params: params }.to change(Like, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }
      let(:band_post) { existent_post }

      it 'responses 401 "Unauthorized"' do
        expect { post '/likes', headers: token, params: params }.to change(Like, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /likes' do
    let(:band_post) { create(:post, band: band) }
    let(:another_post) { create(:post, band: band) }
    let(:params) { { post_id: band_post.id } }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when user has liked the post' do
        before { create(:like, band: band, audience: nil, post: band_post) }

        it 'deletes the Like record' do
          expect { delete '/likes', headers: token, params: params }.to change(Like, :count).by(-1)
          expect(response.status).to eq 200
        end
      end

      context 'when user has not liked the post' do
        before { create(:like, band: band, audience: nil, post: another_post) }

        it 'responses 404 "Not Found"' do
          expect { delete '/likes', headers: token, params: params }.to change(Like, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      context 'when user has liked the post' do
        before { create(:like, band: nil, audience: audience, post: band_post) }

        it 'deletes the Like record' do
          expect { delete '/likes', headers: token, params: params }.to change(Like, :count).by(-1)
          expect(response.status).to eq 200
        end
      end

      context 'when user has not liked the post' do
        before { create(:like, band: nil, audience: audience, post: another_post) }

        it 'responses 404 "Not Found"' do
          expect { delete '/likes', headers: token, params: params }.to change(Like, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { delete '/likes', headers: token, params: params }.to change(Like, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
