class PasswordResetsController < ApplicationController

  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      flash[:notice] = "You're password has been updated."
      user.password = params[:password]
      user.save
      user.update_column(:token, '')
      redirect_to login_path
    else
      redirect_to expired_token_path
    end
  end

end