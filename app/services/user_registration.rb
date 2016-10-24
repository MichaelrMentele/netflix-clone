class UserRegistration
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invitation)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999, 
        :card => stripe_token,
        :description => "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
        self
      else
        @status = :errors
        @error_message = charge.error_message
        self
      end
    else
      @status = :errors
      @error_message = "Invalid user information. Please check the errors below."
      self
    end
  end

  def successful?
    @status == :success

  end

  def handle_invitation(invitation)
    if invitation.present? && invitation[:token].present?
      invitation = Invitation.find_by(token: invitation[:token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end