require 'spec_helper'

describe ReviewsController do
  describe "POST create" do 
    context "with authenticated users" do 
      context "with valid inputs" do 
        let(:video) { Fabricate(:video) }
        let(:current_user) { Fabricate(:user) }
        before do 
          session[:user_id] = current_user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "redirects to video show page" do 
          expect(response).to redirect_to video
        end

        it "create a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with video" do 
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with signed in user" do 
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid input" do 
        let(:video) { Fabricate(:video) }
        let(:current_user) { Fabricate(:user) }
        before { session[:user_id] = current_user.id }

        it "does not create a review" do 
          post :create, review: {rating: 4}, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders the videos/show template" do 
          post :create, review: {rating: 4}, video_id: video.id
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do 
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do 
          existing_review = Fabricate(:review, video_id: video.id)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:reviews)).to match_array([existing_review])
        end
      end
    end
    context "with unauthenticated users" do 
      it "redirects to the sign in path" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end
end