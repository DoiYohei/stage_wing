Rails.application.routes.draw do
  mount_devise_token_auth_for 'Band', at: 'bands', controllers: {
    registrations: 'auth/bands/registrations',
    sessions: 'auth/bands/sessions',
    passwords: 'auth/bands/passwords',
    token_validations: 'auth/bands/token_validations'
  }

  mount_devise_token_auth_for 'Audience', at: 'audiences', controllers: {
    registrations: 'auth/audiences/registrations',
    sessions: 'auth/audiences/sessions',
    passwords: 'auth/audiences/passwords',
    token_validations: 'auth/audiences/token_validations'
  }

  scope format: 'json' do
    resources :events do
      get :edit, on: :member
      resources :lineups, except: :show
    end
    resources :comments, only: %i[create destroy]
    resources :tickets, only: %i[create destroy]
    resources :bands, only: %i[show index edit] do
      resources :friendships, only: :index
      resources :rooms, only: :index
      get :tickets, on: :member
    end
    resources :audiences, only: :edit do
      get :tickets, on: :member
    end
    resources :posts, only: %i[create update destroy]
    resources :likes, only: %i[create index] do
      delete :destroy, on: :collection
    end
    resources :friendships, only: :create do
      delete :destroy, on: :collection
    end
    resources :rooms, only: :create do
      resources :messages, only: :index
    end
  end
end
