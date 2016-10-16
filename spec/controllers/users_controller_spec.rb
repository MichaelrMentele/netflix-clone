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
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates the user" do 
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to login_path
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
      after { ActionMailer::Base.deliveries.clear }
      
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

end