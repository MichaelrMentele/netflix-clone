class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video created."
      redirect_to new_admin_video_path
    else
      flash[:errors] = "There is a problem with your inputs."
      render :new
    end
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:errors] = "You don't have the credentials to do that."
      redirect_to home_path 
    end
  end 

  def video_params
    params.require(:video).permit!
  end 
end