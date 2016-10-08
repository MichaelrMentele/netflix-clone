class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc)}
  NUM_RECENT_VIDEOS = 6

  def recent_videos
    sorted_videos = self.videos
    if sorted_videos.size < NUM_RECENT_VIDEOS
      return sorted_videos
    else
      return sorted_videos[-NUM_RECENT_VIDEOS..-1]
    end
  end

end