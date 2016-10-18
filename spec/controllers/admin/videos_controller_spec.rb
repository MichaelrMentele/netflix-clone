require 'spec_helper'

describe Admin::VideosController do 
  describe "GET new" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end
    it "sets the @video to a new video" do 
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it "redirects non-admins to home path" do 
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets flash error message for non-admins" do 
      set_current_user
      get :new
      expect(flash[:errors]).not_to be_nil
    end
  end

  describe 'POST create' do
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end

    it "redirects non-admins to home path" do 
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    context "valid input" do
      let(:category) { Fabricate(:category) }
      before do 
        set_current_admin
        post :create, video: { title: "monk", category_id: category.id, description: "good show" }
      end

      it "redirects to the add new video page" do 
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do 
        expect(category.videos.count).to eq(1)
      end

      it "sets the flash success method" do 
        expect(flash[:success]).to be_present
      end
    end
    context "invalid input" do 
       let(:category) { Fabricate(:category) }
      before do 
        set_current_admin
        post :create, video: {category_id: category.id, description: "good show" }
      end
      it "does not create a video" do 
        expect(Category.first.videos.count).to eq(0)
      end

      it "renders the :new template" do 
        expect(response).to render_template :new
      end

      it "sets the flash error method" do 
        expect(flash[:errors]).to be_present
      end

      it "sets the @video variable" do 
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end
  end
end