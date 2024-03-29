module Auth
  module Audiences
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      def sign_up_params
        params.permit(:name, :email, :password, :image)
      end

      def account_update_params
        params.permit(:name, :email, :image)
      end
    end
  end
end
