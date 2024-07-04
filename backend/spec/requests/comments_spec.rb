require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:event) { create(:event, owner: band) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'POST /comments' do
    let(:params) { { comment: attributes_for(:comment, event_id: commented_event.id) } }
    let(:non_existent_event) { build_stubbed(:event) }

    context 'when user is a login band' do
      let(:user) { band }

      context 'when event exists' do
        let(:commented_event) { event }

        it 'creates a new Comment record' do
          expect { post '/comments', headers: token, params: params }.to change(Comment, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context 'when event does not exist' do
        let(:commented_event) { non_existent_event }

        it 'responds 404 "Not Found"' do
          expect { post '/comments', headers: token, params: params }.to change(Comment, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      context 'when event exists' do
        let(:commented_event) { event }

        it 'creates a new Comment record' do
          expect { post '/comments', headers: token, params: params }.to change(Comment, :count).by(1)
          expect(response.status).to eq 201
        end
      end

      context 'when event does not exist' do
        let(:commented_event) { non_existent_event }

        it 'responds 404 "Not Found"' do
          expect { post '/comments', headers: token, params: params }.to change(Comment, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }
      let(:commented_event) { event }

      it 'responds 401 "Unauthorized"' do
        expect {post '/comments', headers: token, params: params }.to change(Comment, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /comments/:id' do
    let!(:band_comment) { create(:comment, event: event, audience: nil, band: band) }
    let!(:audience_comment) { create(:comment, event: event, audience: audience, band: nil) }
    let(:band_comment_path) { "/comments/#{band_comment.id}" }
    let(:audience_comment_path) { "/comments/#{audience_comment.id}" }
    let(:another_band) { create(:band) }
    let(:another_audience) { create(:audience) }

    context 'when user is a comment owner band' do
      let(:user) { band }

      it 'deletes the Comment record' do
        expect { delete band_comment_path, headers: token }.to change(Comment, :count).by(-1)
        expect(response.status).to eq 200
      end
    end

    context 'when user is not a comment owner band' do
      let(:user) { another_band }

      it 'responds 404 "Not Found"' do
        expect { delete band_comment_path, headers: token }.to change(Comment, :count).by(0)
        expect(response.status).to eq 404
      end
    end

    context 'when user is a comment owner audience' do
      let(:user) { audience }

      it 'deletes the Comment record' do
        expect { delete audience_comment_path, headers: token }.to change(Comment, :count).by(-1)
        expect(response.status).to eq 200
      end
    end

    context 'when user is not a comment owner audience' do
      let(:user) { another_audience }

      it 'responds 404 "Not Found"' do
        expect { delete audience_comment_path, headers: token }.to change(Comment, :count).by(0)
        expect(response.status).to eq 404
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responds 401 "Unauthorized"' do
        expect { delete band_comment_path, headers: token }.to change(Comment, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
