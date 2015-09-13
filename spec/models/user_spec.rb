require 'spec_helper'

describe User do

  it { should have_many :reviews }
  it { should have_many :queue_items }
  it { should validate_presence_of :email }
  it { should validate_presence_of :full_name }
  it { should validate_uniqueness_of :email }

  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let!(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

  describe '#video_in_queue?' do

    it 'returns true if the video is in users video queue' do
      expect(user.video_in_queue?(video)).to be(true)
    end

    it 'returns fals if the video is not in users video queue' do
      another_video = Fabricate(:video)
      expect(user.video_in_queue?(another_video)).to be(false)
    end
  end


end