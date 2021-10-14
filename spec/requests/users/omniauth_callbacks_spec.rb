require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "GET /github" do
    it "returns http success" do
      get "/users/omniauth_callbacks/github"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /vkontakte" do
    it "returns http success" do
      get "/users/omniauth_callbacks/vkontakte"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /twitter" do
    it "returns http success" do
      get "/users/omniauth_callbacks/twitter"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /facebook" do
    it "returns http success" do
      get "/users/omniauth_callbacks/facebook"
      expect(response).to have_http_status(:success)
    end
  end

end
