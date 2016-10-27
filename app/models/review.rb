class Review < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :user

  validates_presence_of :rating, :description
  validates_inclusion_of :rating, in: 1..5
end