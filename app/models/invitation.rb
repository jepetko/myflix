class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :user
  attr_accessor :message

  validates_presence_of :user
  validates_presence_of :email
end