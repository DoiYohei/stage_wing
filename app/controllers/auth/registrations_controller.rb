class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :authenticate_band!, only: :create

  private
  
  def sign_up_params
    params.permit(:name, :email, :password)
  end

  def account_update_params
    params.permit(:name, :email)
  end

end
