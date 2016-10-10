class QueueItemsController < ApplicationController
  before_filter :require_user
  
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    enqueue(video)
    redirect_to my_queue_path
  end

  private

  def enqueue(video)
    unless duplicate_queue_item?(video)
      queue_item = QueueItem.create(user: current_user, video: video, position: next_position)
    end
  end

  def duplicate_queue_item?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def next_position
    current_user.queue_items.size + 1
  end
end