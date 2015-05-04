class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queue_items, -> { order('order_value') }

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

end