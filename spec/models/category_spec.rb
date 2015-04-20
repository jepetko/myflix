require 'spec_helper'

describe Category do

  it 'saves itself' do
    category = Category.new name: 'Dramas'
    category.save
    expect(Category.first).to eq(category)
  end

  it 'has many videos' do
    category = Category.create(name: 'Dramas')
    south_park = Video.create title: 'South Park', description: 'simsa la bim', avatar: 'video.png', category: category
    monk = Video.create title: 'Monk', description: 'simsa la bim', avatar: 'video.png', category: category

    expect(category.videos).to eq([monk, south_park])
  end

end