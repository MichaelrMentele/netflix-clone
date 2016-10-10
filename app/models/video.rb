class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC'}

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def average_rating
    self.reviews.inject(0) { |sum, review| sum + review.rating } / self.reviews.size
  end
end