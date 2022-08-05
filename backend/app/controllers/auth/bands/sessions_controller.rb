module Auth
  module Bands
    class SessionsController < DeviseTokenAuth::SessionsController
      before_action :authenticate_band!, except: :create
    end
  end
end
