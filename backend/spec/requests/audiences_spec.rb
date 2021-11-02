require 'rails_helper'

RSpec.describe "Audiences", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/audiences/show"
      expect(response).to have_http_status(:success)
    end
  end

end
