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

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if current_user.queue_items.include?(item)
    normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid inputs"
    end

    redirect_to my_queue_path
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do 
      # need to raise an exception to trigger rollback in transaction
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position]) if queue_item.user == current_user
      end
    end
  end

  def normalize_queue_item_positions
    current_user.queue_items.each_with_index do |queue_item, idx|
      queue_item.update_attributes(position: idx + 1)
    end
  end

  def enqueue(video)
    unless duplicate_queue_item?(video)
      QueueItem.create(user: current_user, video: video, position: next_position)
    end
  end

  def duplicate_queue_item?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def next_position
    current_user.queue_items.size + 1
  end
end