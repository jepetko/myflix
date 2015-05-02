class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queued_videos

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

end