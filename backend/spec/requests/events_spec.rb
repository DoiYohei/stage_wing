require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let(:band) { create(:band) }
  let(:another_band) { create(:band) }
  let(:audience) { create(:audience) }
  let(:token) { user ? user.create_new_auth_token : nil }

  describe 'POST /events' do
    let(:params) { { event: attributes_for(:event) } }

    context 'when user is a login band' do
      let(:user) { band }

      it 'creates a new Event record' do
        expect { post '/events', headers: token, params: params }.to change(Event, :count).by(1)
        expect(response.status).to eq 201
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { post '/events', headers: token, params: params }.to change(Event, :count).by(0)
        expect(response.status).to eq 401
      end
    end
    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { post '/events', headers: token, params: params }.to change(Event, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET /events/:id/edit' do
    let(:event) { create(:event, owner: band) }
    let(:edit_path) { "/events/#{event.id}/edit" }

    context 'when user is an event owner' do
      let(:user) { band }

      context 'when event has existed' do
        it 'responses a event data' do
          get edit_path, headers: token
          json = JSON.parse(response.body)
          expect(json['id']).to eq event.id
          expect(response.status).to eq 200
        end
      end

      context 'when event has not existed' do
        let!(:another_event) { build_stubbed(:event, owner: band) }

        it 'responses 404 "Not Found"' do
          get "/events/#{another_event.id}/edit", headers: token
          json = JSON.parse(response.body)
          expect(json['id']).to eq nil
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not an event owner' do
      let(:user) { another_band }

      it 'responses 404 "Not Found"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        get edit_path, headers: token
        json = JSON.parse(response.body)
        expect(json['id']).to eq nil
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /events/:id' do
    let!(:event) { create(:event, owner: band) }
    let(:event_path) { "/events/#{event.id}" }
    let(:params) { { event: attributes_for(:event) } }

    context 'when user is an event owner' do
      let(:user) { band }

      context 'when event has existed' do
        it 'updates the event data' do
          expect(event.name).not_to eq params[:event][:name]
          patch event_path, headers: token, params: params
          event.reload
          expect(event.name).to eq params[:event][:name]
          expect(response.status).to eq 200
        end
      end

      context 'when event has not existed' do
        let!(:another_event) { build_stubbed(:event, owner: band) }

        it 'responses 404 "Not Found"' do
          patch "/events/#{another_event.id}", headers: token, params: params
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not an event owner' do
      let(:user) { another_band }

      it 'responses 404 "Not Found"' do
        expect(event.name).not_to eq params[:event][:name]
        patch event_path, headers: token, params: params
        event.reload
        expect(event.name).not_to eq params[:event][:name]
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect(event.name).not_to eq params[:event][:name]
        patch event_path, headers: token, params: params
        event.reload
        expect(event.name).not_to eq params[:event][:name]
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect(event.name).not_to eq params[:event][:name]
        patch event_path, headers: token, params: params
        event.reload
        expect(event.name).not_to eq params[:event][:name]
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /events/:id' do
    let!(:event) { create(:event, owner: band) }
    let(:event_path) { "/events/#{event.id}" }

    context 'when user is an event owner' do
      let(:user) { band }

      context 'when event has existed' do
        it 'deletes the Event record' do
          expect { delete event_path, headers: token }.to change(Event, :count).by(-1)
          expect(response.status).to eq 200
        end
      end

      context 'when event has not existed' do
        let!(:another_event) { build_stubbed(:event, owner: band) }

        it 'responses 404 "Not Found"' do
          expect { delete "/events/#{another_event.id}", headers: token }.to change(Event, :count).by(0)
          expect(response.status).to eq 404
        end
      end
    end

    context 'when user is not an event owner' do
      let(:user) { another_band }

      it 'responses 404 "Not Found"' do
        expect { delete event_path, headers: token }.to change(Event, :count).by(0)
        expect(response.status).to eq 404
      end
    end

    context 'when user is a login audience' do
      let(:user) { audience }

      it 'responses 401 "Unauthorized"' do
        expect { delete event_path, headers: token }.to change(Event, :count).by(0)
        expect(response.status).to eq 401
      end
    end

    context 'when user is not a login member' do
      let(:user) { nil }

      it 'responses 401 "Unauthorized"' do
        expect { delete event_path, headers: token }.to change(Event, :count).by(0)
        expect(response.status).to eq 401
      end
    end
  end
end
