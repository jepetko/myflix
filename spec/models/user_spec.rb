require 'spec_helper'

describe User do

  it { should have_many :reviews }
  it { should have_many :queue_items }
  it { should validate_presence_of :email }
  it { should validate_presence_of :full_name }
  it { should validate_uniqueness_of :email }
  it { should have_many :followers }
  it { should have_many :followed_users }

  let(:user) { Fabricate(:user) }
  let(:another_user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let!(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

  describe '#video_in_queue?' do

    it 'returns true if the video is in users video queue' do
      expect(user.video_in_queue?(video)).to be(true)
    end

    it 'returns false if the video is not in users video queue' do
      another_video = Fabricate(:video)
      expect(user.video_in_queue?(another_video)).to be(false)
    end
  end

  describe '#follow' do
    it 'creates a relationship to another user' do
      user.follow another_user
      expect(user.followed_users).to include(another_user)
      expect(another_user.followers).to include(user)
    end
  end

  describe '#unfollow' do

    it 'removes the relationship' do
      user.follow another_user
      user.unfollow another_user
      expect(user.followed_users).not_to include(another_user)
    end
  end

  describe '#reset_password?' do
    it 'returns true if the reset_password_token is not empty' do
      user.reset_password_token = SecureRandom.urlsafe_base64
      expect(user.reset_password?).to be_true
    end
    it 'returns false if the reset_token_password is empty' do
      user.reset_password_token = nil
      expect(user.reset_password?).to be_false
    end
  end

end