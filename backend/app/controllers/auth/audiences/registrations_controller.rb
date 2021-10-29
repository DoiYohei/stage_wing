class Auth::Audiences::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :authenticate_audience! , except: :create

  private

  def sign_up_params
    params.permit(:name, :email, :password, :image)
  end

  def account_update_params
    params.permit(:name, :email, :image)
  end
end
