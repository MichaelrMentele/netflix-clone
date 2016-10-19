class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC'}
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def average_rating
    reviews.size > 0 ? rating_sum / reviews.size : 0
  end

  private
  
  def rating_sum
    reviews.inject(0) { |sum, review| sum + review.rating }
  end
end