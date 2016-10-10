class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc)}
  validates_presence_of :tag

  NUM_RECENT_VIDEOS = 6

  def recent_videos
    videos.first(NUM_RECENT_VIDEOS)
  end

end