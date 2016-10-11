class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, {only_integer: true}

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.tag
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      # update column bypasses validation
      review.update_column(:rating, new_rating) 
    else 
      new_review = Review.new(user: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end