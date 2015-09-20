class User < ActiveRecord::Base

  # validates password and password_confirmation; no validates_presence_of necessary!!!
  has_secure_password validations: true
  has_many :queue_items, -> { order('order_value') }
  has_many :reviews, -> { order('created_at DESC') }

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'user_id'
  has_many :followed_users, through: :active_relationships, source: :followed_user

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_user_id'
  has_many :followers, through: :passive_relationships, source: :follower

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes! order_value: index+1
    end
  end

  def video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(user)
    self.followed_users << user
    #Relationship.create(user_id: id, followed_user_id: user.id)
  end

  def unfollow(user)
    self.followed_users.delete user
  end
end