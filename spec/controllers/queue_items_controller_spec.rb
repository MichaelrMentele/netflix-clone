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

  describe "DELETE destroy" do 
    context "auth'd user" do 
      let!(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }
      it "deletes the queue item" do
        queue_item = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item.id 
        expect(QueueItem.count).to eq(0)
      end
      it "redirects back to my queue" do 
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id 
        expect(response).to redirect_to my_queue_path 
      end
      it "does not delete queue items not owned by current user" do 
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id 
        expect(QueueItem.count).to eq(1)
      end
    end

    it "redirects unauth user to login" do 
      delete :destroy, id: 1
      expect(response).to redirect_to login_path
    end
  end

  describe "PATCH update_queue" do 
    context "auth'd user" do 
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid inputs" do 
        it "redirects to my queue" do 
          patch :update_queue, queue_items: []
          expect(response).to redirect_to my_queue_path
        end

        it "reorders queue items" do
          item1 = Fabricate(:queue_item, user: current_user, position: 2)
          item2 = Fabricate(:queue_item, user: current_user, position: 1)
          patch :update_queue, queue_items: [{id: item1.id, position: 1}, {id: item2.id, position: 2}]
          expect(current_user.queue_items).to eq([item1, item2])
        end

        it "normalizes the position numbers" do 
          item1 = Fabricate(:queue_item, user: current_user, position: 1)
          item2 = Fabricate(:queue_item, user: current_user, position: 2)
          patch :update_queue, queue_items: [{id: item1.id, position: 3}, {id: item2.id, position: 2}]
          expect(item1.reload.position).to eq(2)
          expect(item2.reload.position).to eq(1)
        end
      end

      context "with invalid inputs" do 
        let(:item) { Fabricate(:queue_item, user: current_user, position: 1) }
        before { patch :update_queue, queue_items: [{id: item.id, position: 2.5}] }
        it "redirects to the my queue page" do 
          expect(response).to redirect_to my_queue_path
        end

        it "sets the flash error message" do
          expect(flash[:error]).to be_present
        end

        it "does not change the queue items" do 
          expect(item.reload.position).to eq(1)
        end
      end

      context "with queue items that do not belong to the current user" do 
        it "does not change the queue items" do 
          bob = Fabricate(:user)
          item1 = Fabricate(:queue_item, user: bob, position: 1)
          item2 = Fabricate(:queue_item, user: bob, position: 2)
          patch :update_queue, queue_items: [{id: item1.id, position: 3}, {id: item2.id, position: 2}]
          expect(item1.position).to eq(1)
        end
      end
    end

    context "invalid user" do 
      it "redirects to login" do
        # no user so patch will be filtered
        patch :update_queue
        expect(response).to redirect_to login_path
      end
    end
  end
end