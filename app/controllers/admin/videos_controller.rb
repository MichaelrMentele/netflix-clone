class Admin::VideosController < AdminsController

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

  def video_params
    params.require(:video).permit!
  end 
end