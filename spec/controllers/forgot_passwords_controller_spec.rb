require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context "with blank input" do
      it "redirects to forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do 
        post :create, email: ''
        expect(flash[:errors]).not_to be_nil
      end
    end

    context "with existing email" do 
      before { ActionMailer::Base.deliveries.clear }
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "test@test.com")
        post :create, email: 'test@test.com'
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "sends an email to the email address" do
        Fabricate(:user, email: "test@test.com")
        post :create, email: 'test@test.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
      end
    end

    context "with non-existent email" do 
      it "redirects to the forgot password page" do
        post :create, email: "test@test.com"
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do 
        post :create, email: "test@test.com"
        expect(flash[:errors]).not_to be_nil
      end
    end
  end
end