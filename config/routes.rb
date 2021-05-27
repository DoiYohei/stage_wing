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
    resources :events
    resources :bands, only: [:index, :show]
  end
end
