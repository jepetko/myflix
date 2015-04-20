require 'spec_helper'

describe Video do

  it 'saves itself' do
    video = Video.new title: 'my video', description: 'simsa la bim', avatar: 'video.png'
    video.save
    expect(Video.first).to eq(video)
  end

  it 'belongs to a category' do
    category = Category.new name: 'Dramas'
    expect(Video.new).to respond_to(:category)
    video = Video.new title: 'my video', description: 'simsa la bim', avatar: 'video.png', category: category
    video.save
    expect(video.category).to eq(category)
    video.title.should == 'my video'
  end

  it { should belong_to(:category)}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

end