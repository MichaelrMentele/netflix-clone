require 'spec_helper'

describe VideosController do
  describe "GET show" do 
    context "authenticated user" do 
      let(:video) { Fabricate(:video) }
      before { set_current_user }

      it "sets @video" do 
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews" do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)

        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
    it "redirects unauthenticated users to the sign in page" do 
      video = Fabricate(:video)

      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end

  describe "GET search" do 
    it "sets @results if user authenticated" do 
      set_current_user
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