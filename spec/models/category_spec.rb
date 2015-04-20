require 'spec_helper'

describe Category do

  it 'saves itself' do
    category = Category.new name: 'Dramas'
    category.save
    expect(Category.first).to eq(category)
  end

  it 'has many videos' do
    category = Category.new name: 'Dramas'
    expect(category).to respond_to(:videos)
    category.videos.build title: 'my video', description: 'simsa la bim', avatar: 'video.png'
    category.save
    expect(category.videos.first.title).to eq('my video')
  end

end