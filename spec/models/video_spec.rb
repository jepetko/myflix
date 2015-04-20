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

  describe '#search_by_title' do

    context 'the search term is family' do
      context 'there are videos Family Guy, Family Affairs, Monk' do

        before(:each) do
          Video.create title: 'Family Guy', description: 'lorem ipsum'
          Video.create title: 'Family Affairs', description: 'lorem ipsum'
          Video.create title: 'Monk', description: 'lorem ipsum'
        end

        it 'finds Family Guy and Family Affairs' do
          found_titles = Video.search_by_title('family').collect(&:title)
          expect(found_titles).to include('Family Guy')
          expect(found_titles).to include('Family Affairs')
        end
      end

      context 'there are videos Futurama and Boyhood' do

        before(:each) do
          Video.create title: 'Futurama', description: 'lorem ipsum'
          Video.create title: 'Boyhood', description: 'lorem ipsum'
        end

        it 'finds nothing' do
          expect(Video.search_by_title('family')).to be_empty
        end
      end

      context 'there are videos Monk and My small family' do

        before(:each) do
          Video.create title: 'Monk', description: 'lorem ipsum'
          Video.create title: 'My small family', description: 'lorem ipsum'
        end

        it 'finds My small family' do
          found_titles = Video.search_by_title('family').collect(&:title)
          expect(found_titles).to include('My small family')
        end
      end
    end
  end
end