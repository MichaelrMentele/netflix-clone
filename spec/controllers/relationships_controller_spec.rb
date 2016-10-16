require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do 
    it "sets @relationships to the current_users following relationships" do
      alice = Fabricate(:user)
      set_current_user(user: alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    before { set_current_user(user: alice) }

    it "deletes the relationship if the current user is the follower" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    it "redirects to the people page" do
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "does not delete the relationship if current user is NOT the follower" do
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 4 }
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    before { set_current_user(user: alice) }

    it "creates a relationship where the current user is the follower" do 
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end
    it "does not allow a user to follow the same user more than once" do
      Fabricate(:relationship, leader_id: bob.id, follower: alice)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.count).to eq(1)
    end
    it "redirects to the current users people page" do 
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end
    it "does not allow one to follow themselves" do 
      post :create, leader_id: alice.id
      expect(alice.following_relationships.count).to eq(0)
    end
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, leader_id: bob.id}
    end
  end
end