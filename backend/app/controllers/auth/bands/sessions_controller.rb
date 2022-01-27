class Auth::Bands::SessionsController < DeviseTokenAuth::SessionsController
  before_action :authenticate_band!, except: :create
end
