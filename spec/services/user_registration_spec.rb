require 'spec_helper'

describe UserRegistration do 
  describe "#register" do 
    context "valid personal info and valid card" do 
      let(:charge) { double(:charge, successful?: true)}
      before do 
        StripeWrapper::Charge.should_receive(:create) { charge }
      end

      context 'and no token' do 
        it "creates the user" do 
          UserRegistration.new(Fabricate.build(:user)).register("some_stripe_token", nil )
          expect(User.count).to eq(1)
        end
      end

      context "with invite token" do 
        let(:alice) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com") }
        before do 
          UserRegistration.new(Fabricate.build(:user, email: 'joe@example.com', password: "password", username: "joe")).register("some_stripe_token", token: invitation.token )
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

        it "sends an email to the new user with valid inputs" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
        end

        it "sends an email containing users name with valid input" do
          expect(ActionMailer::Base.deliveries.last.body).to include("joe")
        end
      end
    end

    context "valid personal info and declined" do 
      let (:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }
      before do 
        
      end
      it "does not create a new user record" do 
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        UserRegistration.new(Fabricate.build(:user)).register('12345', nil) 
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do 
      
      it "does not create the user" do 
        UserRegistration.new(User.new(email: "m")).register('12345', nil) 
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do 
        StripeWrapper::Charge.should_receive(:create).never
        UserRegistration.new(User.new(email: "m")).register('12345', nil) 
      end

      it "does not send email with invalid inputs" do
        UserRegistration.new(User.new(email: "m")).register('12345', nil) 
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end

