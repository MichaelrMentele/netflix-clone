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
    context "with valid input" do
      context "and no token" do 
        before { post :create, user: Fabricate.attributes_for(:user) }

        it "creates the user" do 
          expect(User.count).to eq(1)
        end

        it "redirects to the sign in page" do
          expect(response).to redirect_to login_path
        end
      end 

      context "with invite token" do 
        let(:alice) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com") }
        before do 
          post :create, user: { email: 'joe@example.com', password: "password", username: "joe" }, invitation_token: invitation.token
        end

        it "makes the user follow inviter" do 
          joe = User.find_by(email: 'joe@example.com')
          expect(joe.follows?(alice)).to be_true
        end

        it "makes inviter follow the user" do 
          joe = User.find_by(email: 'joe@example.com')
          expect(alice.follows?(joe)).to be_true
        end

        it "expires the invitation upon acceptance" do 
          expect(Invitation.first.token).to be_nil
        end
      end
    end

    context "with invalid input" do 
      before { post :create, user: { password: 'password', username: "m"} }

      it "does not create the user" do 
        expect(User.count).to eq(0)
      end

      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "sets @user" do 
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "sending emails" do
      before { ActionMailer::Base.deliveries.clear }
      
      it "sends an email to the new user with valid inputs" do
        post :create, user: { password: 'pass', username: 'mike', email: 'test@test.com'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
      end
      it "sends an email containing users name with valid input" do
        post :create, user: { password: 'pass', username: 'mike', email: 'test@test.com'}
        expect(ActionMailer::Base.deliveries.last.body).to include("mike")
      end
      it "does not send email with invalid inputs" do
        post :create, user: { email: 'test@test.com'}
        expect(ActionMailer::Base.deliveries).to be_empty
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
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end 

    it "redirects to expired token page for invalid tokens" do 
      get :new_with_invitation_token, token: "adfasdf"
      expect(response).to redirect_to expired_token_path
    end
  end
end