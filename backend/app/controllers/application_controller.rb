class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ErrorRenderable
  devise_token_auth_group :member, contains: %i[band audience]
end
