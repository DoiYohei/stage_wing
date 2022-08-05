module Auth
  module Audiences
    class SessionsController < DeviseTokenAuth::SessionsController
      before_action :authenticate_audience!, except: :create
    end
  end
end
