require 'spec_helper'

describe PasswordResetsController do 
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do 
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: 'old_pw')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_pw'
        expect(response).to redirect_to login_path
      end
      it "updates the user's password" do 
        alice = Fabricate(:user, password: 'old_pw')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_pw'
        expect(alice.reload.authenticate('new_pw').save).to be true
      end
      it "sets the flash success message" do 
        alice = Fabricate(:user, password: 'old_pw')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_pw'
        expect(flash[:notice]).not_to be_nil
      end
      it "clears the users token" do
        alice = Fabricate(:user, password: 'old_pw')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_pw'
        expect(alice.reload.token).to eq('')
      end
    end
    context "with invalid token" do
      it "redirect to expired token path" do
        post :create, token: '12345', password: 'some_pw'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end