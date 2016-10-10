require 'spec_helper'

describe QueueItemsController do 
  describe "GET index" do 
    it "sets @queue_items to items of current user" do 
      alice = Fabricate(:user)
      session[:user_id] = alice.id 
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to sign in for unauthenticated users" do 
      get :index
      expect(response).to redirect_to login_path
    end
  end
  describe "POST create" do 
    let(:video) { Fabricate(:video) }
    context "authenticated user" do 
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      it "redirects to my queue page" do 
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      it "creates a queue item" do 
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates the queue item associated with video" do 
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates the queue item associated with current user" do 
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
      it "it puts the video as the last one in the view" do 
        item1 = Fabricate(:queue_item, user: current_user, video: video)
        monk = Fabricate(:video)
        post :create, video_id: monk.id
        monk_queue_item = QueueItem.where(video_id: monk.id, user_id: current_user.id).first
        expect(monk_queue_item.position).to eq(2)
      end
      it "it does not add the video to the queue if the video is already in the queue" do 
        post :create, video_id: video.id
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
    end
    context "unauthenticated user" do 
      it "redirects to the sign in page" do 
        post :create, video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end
end