require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  context "POST #create" do
    it "is invalid without authentication" do
      post "/friendships"
      expect(response).to have_http_status "401"
    end
  end
  context "DELETE #destroy" do
    it "is invalid without authentication" do
      delete "/friendships/1"
      expect(response).to have_http_status "401"
    end
  end
end
