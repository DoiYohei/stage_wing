module Auth
  module Bands
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      def sign_up_params
        params.permit(:name, :email, :password, :image, :profile, :website, :twitter)
      end

      def account_update_params
        params.permit(:name, :email, :image, :profile, :website, :twitter)
      end
    end
  end
end
