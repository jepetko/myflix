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
      context 'there are videos "Family Guy", "Family Affairs", "Monk"' do
        it 'finds "Family Guy" and "Family Affairs"' do
          family_guy = Video.create title: 'Family Guy', description: 'lorem ipsum'
          family_affairs = Video.create title: 'Family Affairs', description: 'lorem ipsum'
          monk = Video.create title: 'Monk', description: 'lorem ipsum'

          expect(Video.search_by_title('family')).to eq([family_guy, family_affairs])
        end
      end

      context 'there are videos "Futurama" and "Boyhood"' do
        it 'finds nothing' do
          futurama = Video.create title: 'Futurama', description: 'lorem ipsum'
          boyhood = Video.create title: 'Boyhood', description: 'lorem ipsum'

          expect(Video.search_by_title('family')).to eq([])
        end
      end

      context 'there are videos "Monk" and "My small family"' do
        it 'finds "My small family" as a partial match' do
          monk = Video.create title: 'Monk', description: 'lorem ipsum'
          my_small_family = Video.create title: 'My small family', description: 'lorem ipsum'
          expect(Video.search_by_title('family')).to eq([my_small_family])
        end
      end

      context 'there are videos "Monk" and "family"' do
        it 'finds "family" as an exact match' do
          monk = Video.create title: 'Monk', description: 'lorem ipsum'
          family = Video.create title: 'family', description: 'lorem ipsum'
          expect(Video.search_by_title('family')).to eq([family])
        end
      end
    end
  end
end