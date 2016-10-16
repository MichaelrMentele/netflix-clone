class ReviewsController < ApplicationController
  before_filter :require_user
  
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params.merge!(user: current_user))
    if @review.save  
      flash[:notice] = "Your review has been added!"  
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      flash[:errors] = "Your review failed."
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit!
  end
end