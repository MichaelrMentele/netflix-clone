require 'spec_helper'

describe VideosController do
  describe "GET show" do 
    context "with authenticated user" do 
      before do 
        session[:user_id] = Fabricate(:user).id
      end
      
      it "sets @video" do 
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      it "renders the show template" do 

      end
    end
  end

  describe "GET search" do 

  end
end