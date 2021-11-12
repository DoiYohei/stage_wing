class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        devise_token_auth_group :member, contains: %i(band audience)
end
