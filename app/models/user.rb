class User < ActiveRecord::Base
  has_many :reviews, -> {order "created_at DESC"}
  has_many :queue_items, -> { order "position ASC"}
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id

  validates_presence_of :email, :password, :username
  validates_uniqueness_of :email

  has_secure_password validations: false

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, idx|
      queue_item.update_attributes(position: idx + 1)
    end
  end

  def in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(leader)
    Relationship.create(leader_id: leader.id, follower_id: id) unless self == leader
  end

  def follows?(leader)
    Relationship.where(leader_id: leader.id, follower_id: id).exists?
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end