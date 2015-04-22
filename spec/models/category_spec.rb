require 'spec_helper'

describe Category do

  it 'saves itself' do
    category = Category.new name: 'Dramas'
    category.save
    expect(Category.first).to eq(category)
  end

  it { should have_many(:videos) }

  describe '#recent_videos' do
    let(:category) { Category.new(name: 'Dramas') }

    before(:each) do
      (1..12).each do |i|
        Video.create title: "Video #{i}", description: 'Lorem ipsum', category: category, created_at: i.day.ago
      end
    end

    it 'returns 6 videos' do
      expect(category.recent_videos.size).to be(6)
    end

    it 'returns the videos sorted by created_at timestamp in the descending order' do
      videos = category.recent_videos

      expected_videos = []
      (1..6).each { |i| expected_videos << Video.find_by(title: "Video #{i}")}
      expect(videos).to eq(expected_videos)
    end

    it 'returns all videos if there are less than 6 videos' do
      category = Category.new(name: 'Comedies')
      futurama = Video.create title: 'Futurama', description: 'lorem ipsum', category: category, created_at: 1.minute.ago
      hellboy = Video.create title: 'Hellboy', description: 'lorem ipsum', category: category

      expect(category.recent_videos).to eq([hellboy, futurama])
    end

    it 'returns an empty array if there are no videos in the category' do
      category = Category.new(name: 'Comedies')
      expect(category.recent_videos).to be_empty
    end
  end
end