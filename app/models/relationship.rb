class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "User"

  def unique?
    Relationship.where(leader_id: leader_id, follower_id: follower_id).count == 0
  end

  def follow_self?
    leader_id == follower_id
  end
end