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
end