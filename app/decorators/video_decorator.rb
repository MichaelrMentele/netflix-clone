class VideoDecorator
  attr_reader :video

  def initialize(video)
    @video = video 
  end

  def average_rating
    video.reviews.size > 0 ? rating_sum / video.reviews.size : 0
  end

  private
  
  def rating_sum
    video.reviews.inject(0) { |sum, review| sum + review.rating }
  end
end