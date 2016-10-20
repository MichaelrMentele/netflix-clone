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
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true)}
      before do 
        StripeWrapper::Charge.should_receive(:create) { charge }
      end

      context "and no token" do 
        before do 
          post :create, user: Fabricate.attributes_for(:user) 
        end

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
          post :create, user: { email: 'joe@example.com', password: "password", username: "joe" }, invitation: { token: invitation.token }
        end

        it "makes the user follow inviter" do 
          joe = User.find_by(email: 'joe@example.com')
          expect(joe.follows?(alice)).to eq(true)
        end

        it "makes inviter follow the user" do 
          joe = User.find_by(email: 'joe@example.com')
          expect(alice.follows?(joe)).to eq(true)
        end

        it "expires the invitation upon acceptance" do 
          expect(Invitation.first.token).to be_nil
        end
      end
    end

    context "valid personal info and declined" do 
      let (:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }
      before do 
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user, Token: '123456')
      end
      it "does not create a new user record" do 
        expect(User.count).to eq(0)
      end

      it "renders the new template" do 
        expect(response).to render_template :new
      end

      it "sets the flash error message" do 
        expect(flash[:errors]).to be_present
      end
    end

    context "with personal info" do 
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

      it "does not charge the card" do 
        StripeWrapper::Charge.stub(:create)
        post :create, user: { email: "k@wang.com" }
      end
    end

    context "sending emails" do
      let(:charge) { double(:charge, successful?: true)}

      it "sends an email to the new user with valid inputs" do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: { password: 'pass', username: 'mike', email: 'test@test.com'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
      end

      it "sends an email containing users name with valid input" do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: { password: 'pass', username: 'mike', email: 'test@test.com'}
        expect(ActionMailer::Base.deliveries.last.body).to include("mike")
      end
      it "does not send email with invalid inputs" do
        StripeWrapper::Charge.should_not_receive(:create)
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
        expect(assigns(:invitation)).to eq(invitation)
      end
    end 

    it "redirects to expired token page for invalid tokens" do 
      get :new_with_invitation_token, token: "adfasdf"
      expect(response).to redirect_to expired_token_path
    end
  end
end
