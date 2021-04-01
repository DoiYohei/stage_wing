class Auth::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :authenticate_band!, only: :create
end
