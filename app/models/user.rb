class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order "position ASC"}
  
  validates_presence_of :email, :password, :username
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, idx|
      queue_item.update_attributes(position: idx + 1)
    end
  end

end