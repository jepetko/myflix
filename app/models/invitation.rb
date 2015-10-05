class Invitation < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :email
  validates_presence_of :token
end