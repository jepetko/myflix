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
  end

  it 'does not save a video without a title' do
    video = Video.new
    expect(video).to_not be_valid
    expect(video.errors.messages[:title]).to include("can't be blank")
    expect(video.save).to be(false)
  end

  it 'does not save a video without a description' do
    video = Video.new title: 'Futurama'
    expect(video).to_not be_valid
    expect(video.errors.messages[:description]).to include("can't be blank")
    expect(video.save).to be(false)
  end

end