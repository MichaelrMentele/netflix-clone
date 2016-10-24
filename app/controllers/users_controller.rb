class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    result = UserRegistration.new(@user).register(params[:stripeToken], params[:invitation])

    if result.successful?
      flash[:notice] = "Thank you for registering with MyFlix. Please sign in now."
      redirect_to login_path
    else
      flash[:errors] = result.error_message
      render :new
    end
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @invitation = invitation
      @user = User.new(email: invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end