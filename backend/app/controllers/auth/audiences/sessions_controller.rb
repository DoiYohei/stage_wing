class Auth::Audiences::SessionsController < DeviseTokenAuth::SessionsController
  before_action :authenticate_audience!, expect: :create
end
