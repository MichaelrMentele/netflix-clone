class VideosController < ApplicationController
  before_filter :require_user

  def index
    @videos = Video.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def advanced_search
    options = {
      rating_from: params[:rating_from],
      rating_to: params[:rating_to],
      reviews: params[:search_reviews_enable] == 'y'
    }

    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    else
      @videos = []
    end
  end

end

