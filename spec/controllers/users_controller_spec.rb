require 'spec_helper'

describe UsersController do 
  describe "GET new" do 
    it "sets @user" do 
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end
    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "POST create" do 
    context "successful registration" do
      context "no token" do 
        it "redirects to the sign in page" do
          result = double(:result, successful?: true)
          UserRegistration.any_instance.stub(:register).and_return(result)
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to login_path
        end
      end 
    end

    context "failed registration" do 
      let(:result) { double(:result, successful?: false, error_message: "Error message") }
      before do 
        UserRegistration.any_instance.stub(:register).and_return(result)
        post :create, user: { username: 'm' }
      end
      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "sets @user" do 
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "sets the flash error message" do 
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe 'GET new_with_invitation_token' do 
    context "with valid token" do 
      let(:invitation) { Fabricate(:invitation) }
      before do 
        get :new_with_invitation_token, token: invitation.token
      end

      it "renders the :new view template" do 
        expect(response).to render_template :new
      end

      it "sets @user with recipient's email" do 
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it "sets @invitation_token" do 
        expect(assigns(:invitation)).to eq(invitation)
      end
    end 

    it "redirects to expired token page for invalid tokens" do 
      get :new_with_invitation_token, token: "adfasdf"
      expect(response).to redirect_to expired_token_path
    end
  end
end
