class User < ActiveRecord::Base

  attr_accessor :password_confirmation
  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
  validate :password_equality

  def password_equality
    if password != password_confirmation
      errors.add(:password_confirmation, "doesn't match the password")
    end
  end

end