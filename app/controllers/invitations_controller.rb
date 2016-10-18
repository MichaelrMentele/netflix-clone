class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      flash[:notice] = "Your invitation has been sent"
      AppMailer.delay.send_invitation_email(@invitation)
      redirect_to new_invitation_path
    else 
      flash[:errors] = "Your invitation failed to send. Please review your information."
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit!
  end
end