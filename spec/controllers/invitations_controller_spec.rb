require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do 
    it "sets @invitation" do 
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end
  end 

  describe "POST create" do
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end

    context "with valid input" do
      before do 
        set_current_user 
        post :create, invitation: { recipient_name: "Joe", recipient_email: "Joe@example.com", message: "hey join!" }
      end

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to invitation new page" do 
        expect(response).to redirect_to new_invitation_path
      end

      it "create an invitation" do 
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do 
        expect(ActionMailer::Base.deliveries.last.to).to eq(['Joe@example.com'])
      end

      it "sets the flash success message" do 
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid input" do 
      before do 
        set_current_user 
        post :create, invitation: { recipient_name: "Joe" }
      end 

      after { ActionMailer::Base.deliveries.clear }

      it "renders the invite page" do 
        expect(response).to render_template :new
      end

      it "does not create an invitation" do 
        expect(Invitation.count).to eq(0)
      end

      it "does not send an email" do 
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do 
        expect(flash[:errors]).to be_present
      end

      it "sets @invitation" do 
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end