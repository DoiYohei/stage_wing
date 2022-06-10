Rails.application.routes.draw do
  mount_devise_token_auth_for "Band", at: "bands", controllers: {
    registrations: "auth/bands/registrations",
    sessions: "auth/bands/sessions",
    passwords: "auth/bands/passwords",
    token_validations: "auth/bands/token_validations"
  }
  
  mount_devise_token_auth_for "Audience", at: "audiences", controllers: {
    registrations: "auth/audiences/registrations",
    sessions: "auth/audiences/sessions",
    passwords: "auth/audiences/passwords",
    token_validations: "auth/audiences/token_validations"
  }
  
  scope format: "json" do
    resources :events do
      get :edit, on: :member
      resources :lineups, except: :show
      resources :comments, only: %i(create destroy)
    end
    resources :tickets, only: %i(create destroy)
    resources :bands, only: %i(show index edit) do
      member do
        get :friendships
        get :tickets
      end
    end
    resources :audiences, only: :edit do
      get :tickets, on: :member
    end
    resources :posts, only: %i(create update destroy)
    resources :likes, only: %i(create index) do
      delete :destroy, on: :collection
    end
    resources :friendships, only: :create do
      delete :destroy, on: :collection
    end
    resources :rooms, only: %i(index create) do
      resources :messages, only: :index
    end
  end
end
