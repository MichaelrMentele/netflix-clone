class ForgotPasswordsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user
      AppMailer.delay.send_forgot_password(@user)
      redirect_to forgot_password_confirmation_path
    else
      if params[:email].blank?
        flash[:errors] = "Email cannot be blank."
      else
        flash[:errors] = "That email does not exist."
      end
      redirect_to forgot_password_path
    end    
  end

  def confirm;  end

  def new;  end
end