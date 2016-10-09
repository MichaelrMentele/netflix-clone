require 'spec_helper'

describe VideosController do
  describe "GET show" do 
    it "sets @video if user authenticated" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)

      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects unauthenticated users to the sign in page" do 
      video = Fabricate(:video)

      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end

  describe "GET search" do 
    it "sets @results if user authenticated" do 
      session[:user_id] = Fabricate(:user).id
      test = Fabricate(:video, title: "test")

      get :search, search_term: "est"
      expect(assigns(:results)).to eq([test])
    end

    it "it redirects to login for unauthenticated users" do 
      test = Fabricate(:video, title: "test")

      get :search, search_term: "est"
      expect(response).to redirect_to login_path
    end
  end
end