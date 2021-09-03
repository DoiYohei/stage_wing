Rails.application.routes.draw do
  mount_devise_token_auth_for 'Band', at: 'auth', skip: [:registrations], controllers: {
    sessions: 'auth/sessions'
  }
  
  devise_scope :band do
    post '/auth/sign_up', to: 'auth/registrations#create', as: :user_registration
    patch '/auth/account/edit', to: 'auth/registrations#update', as: :edit_user_registration
    delete '/auth/account/delete', to: 'auth/registrations#destroy', as: :destroy_user_registration
  end

  scope format: 'json' do
    resources :events do
      resources :lineups
    end
    resources :bands, only: %i(show index) do
      member do
        get :friendships
      end
    end
    resources :posts, only: %i(index create edit update destroy)
    resource :friendships, only: %i(create destroy)
    resource :likes, only: %i(create destroy)
  end
end
