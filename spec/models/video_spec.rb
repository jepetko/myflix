require 'spec_helper'

describe Video do

  it { should belong_to(:category)}
  it { should have_many(:reviews).order('created_at DESC')}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'saves itself' do
    video = Video.new title: 'my video', description: 'simsa la bim', small_cover: 'video.png'
    video.save
    expect(Video.first).to eq(video)
  end

  it 'belongs to a category' do
    category = Category.new name: 'Dramas'
    expect(Video.new).to respond_to(:category)
    video = Video.new title: 'my video', description: 'simsa la bim', small_cover: 'video.png', category: category
    video.save
    expect(video.category).to eq(category)
    expect(video.title).to eq 'my video'
  end


  describe '#search_by_title' do

    context 'the search term is an empty string' do
      context 'for any videos in the database' do
        it 'returns an empty array' do
          futurama = Video.create title: 'Futurama', description: 'lorem ipsum'
          boyhood = Video.create title: 'Boyhood', description: 'lorem ipsum'
          expect(Video.search_by_title('')).to eq([])
        end
      end
    end

    context 'the search term is family' do
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

      context 'there are videos "Family Guy", "Family Affairs", "Monk"' do
        it 'finds "Family Guy" and "Family Affairs" as a partial match' do
          family_guy = Video.create title: 'Family Guy', description: 'lorem ipsum'
          family_affairs = Video.create title: 'Family Affairs', description: 'lorem ipsum'
          monk = Video.create title: 'Monk', description: 'lorem ipsum'

          expect(Video.search_by_title('family')).to eq([family_affairs, family_guy])
        end

        it 'returns them ordered by created_at' do
          family_guy = Video.create title: 'Family Guy', description: 'lorem ipsum', created_at: 1.day.ago
          family_affairs = Video.create title: 'Family Affairs', description: 'lorem ipsum'
          monk = Video.create title: 'Monk', description: 'lorem ipsum'

          expect(Video.search_by_title('family')).to eq([family_affairs, family_guy])
        end
      end
    end
  end

  describe '#calculate_rating_average' do
    it 'returns the average of all ratings' do
      video = Fabricate(:video)
      (1..5).each do |rating|
        video.reviews.create(Fabricate.attributes_for(:review, rating: rating))
      end
      expect(video.calculate_rating_average).to eq(3.0)
    end

    it 'returns 0 if there are no ratings' do
      video = Fabricate(:video)
      expect(video.calculate_rating_average).to eq(0)
    end

    it 'returns a rounded value' do
      video = Fabricate(:video)
      [1,2,5].each do |rating|
        video.reviews.create(Fabricate.attributes_for(:review, rating: rating))
      end
      expect(video.calculate_rating_average).to eq(2.67)
    end
  end

end