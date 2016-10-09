require 'spec_helper'

describe SessionsController do 
  describe "GET new" do 
    it "redirects to home if current user" do 
      session[:user_id] = Fabricate(:user).id

      get :new
      expect(response).to redirect_to home_path
    end

    it "renders new if no current user" do 
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do 
    context "valid credentials" do 
      let(:alice) { alice = Fabricate(:user) }

      before { post :create, email: alice.email, password: alice.password }
      
      it "sets a user id in the session" do  
        expect(session[:user_id]).to eq(alice.id)
      end
      it "redirects to home" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice" do 
        expect(flash[:notice]).not_to be_blank 
      end
    end

    context "invalid credentials" do 
      let(:alice) { alice = Fabricate(:user) }
      before { post :create }

      it "sets a flash error" do 
        expect(flash[:error]).not_to be_blank
      end

      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "does not put the user in the session" do 
        expect(session[:user_to]).to be_nil
      end
    end
  end

  describe "POST destroy" do 

  end
end