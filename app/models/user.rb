class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order "position ASC"}
  
  validates_presence_of :email, :password, :username
  validates_uniqueness_of :email

  has_secure_password validations: false
end