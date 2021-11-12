class Auth::SessionsController < DeviseTokenAuth::SessionsController
  before_action :authenticate_band!, except: :create
end
