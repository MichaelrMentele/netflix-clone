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
    if @user.save
      handle_invitation
      AppMailer.send_welcome_email(@user).deliver
      redirect_to login_path
    else
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

  def handle_invitation
    if params[:invitation][:token].present?
      invitation = Invitation.find_by(params[:invitation])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end