module AuthorizationHelper
  def sign_in(band)
    post "/bands", params: band
    response.headers.slice("client", "uid", "token-type", "access-token")
  end
end
