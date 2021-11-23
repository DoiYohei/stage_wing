Rails.application.routes.draw do
  get 'home/index'
  mount_devise_token_auth_for "Band", at: "auth", skip: [:registrations], controllers: {
    sessions: "auth/sessions",
    passwords: "bands/passwords",
    token_validations: "bands/token_validations"
  }
  devise_scope :band do
    post "/auth/sign_up", to: "auth/registrations#create", as: :user_registration
    patch "/auth/account/edit", to: "auth/registrations#update", as: :update_band_registration
    delete "/auth/account/delete", to: "auth/registrations#destroy", as: :destroy_band_registration
  end
  
  mount_devise_token_auth_for "Audience", at: "audiences", controllers: {
    registrations: "auth/audiences/registrations",
    sessions: "auth/audiences/sessions",
    passwords: "auth/audiences/passwords",
    token_validations: "auth/audiences/token_validations"
  }
  
  scope format: "json" do
    resources :events do
      resources :lineups, except: :show
      resources :comments, only: %i(create destroy)
      resources :tickets, only: %i(new create destroy)
    end
    resources :bands, only: %i(show index) do
      member do
        get :friendships
        get :tickets
      end
    end
    resources :audiences, only: %i(show index) do
      member do
        get :tickets
      end
    end
    resources :posts, only: %i(index create edit update destroy)
    resources :rooms, only: %i(index create) do
      resources :messages, only: :index
    end
    root "home#index"
    get "/likes", to: "likes#index"
    post "/likes", to: "likes#create"
    delete "/likes", to: "likes#destroy"
    post "/friendships", to: "friendships#create"
    delete "/friendships", to: "friendships#destroy"
  end
end
