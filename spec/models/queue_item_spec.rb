require 'spec_helper'

describe QueueItem do

  it { should respond_to(:video) }
  it { should respond_to(:order_value) }
  it { should respond_to(:user) }

  it { should belong_to(:video) }
  it { should belong_to(:user) }

  it { should validate_presence_of :video }
  it { should validate_presence_of :user }

  describe '#video_title' do

    let(:user) { user = Fabricate(:user)}

    it 'returns the title of the associated video' do
      video = Fabricate(:video, title: 'Monk')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq 'Monk'
    end

  end

  describe '#video_rating' do

    let(:video) { video = Fabricate(:video, title: 'Monk') }
    let(:user) { user = Fabricate(:user)}

    it 'returns the rating of the associated video' do
      Fabricate(:review, video: video, user: user, rating: 2)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.video_rating).to eq 2
    end

    it 'returns the last rated value if there are many ratings made by the same user' do
      Fabricate(:review, video: video, user: user, rating: 2, created_at: 1.hour.ago)
      Fabricate(:review, video: video, user: user, rating: 4)

      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.video_rating).to eq 4
    end

    it 'returns nil if there is no rating yet' do
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.video_rating).to be_nil
    end
  end

  describe '#video_category' do

    it 'returns the category name of the associated video' do
      category = Fabricate(:category, name: 'Dramas')
      video = Fabricate(:video, title: 'Monk', category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq 'Dramas'
    end
  end
end