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

  describe '#search', :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context 'with title' do
      it "returns no results when there's no match" do
        Fabricate(:video, title: 'Futurama')
        refresh_index

        expect(Video.search('whatever').records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search('').records.to_a).to eq []
      end

      it 'returns an array of 1 video for title case insensitve match' do
        futurama = Fabricate(:video, title: 'Futurama')
        south_park = Fabricate(:video, title: 'South Park')
        refresh_index

        expect(Video.search('futurama').records.to_a).to eq [futurama]
      end

      it 'returns an array of many videos for title match' do
        star_trek = Fabricate(:video, title: 'Star Trek')
        star_wars = Fabricate(:video, title: 'Star Wars')
        refresh_index

        expect(Video.search('star').records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context 'with title and description' do
      it 'returns an array of many videos based for title and description match' do
        star_wars = Fabricate(:video, title: 'Star Wars')
        about_sun = Fabricate(:video, description: 'sun is a star')
        refresh_index

        expect(Video.search('star').records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context 'multiple words must match' do
      it 'returns an array of videos where 2 words match title' do
        star_wars_1 = Fabricate(:video, title: 'Star Wars: Episode 1')
        star_wars_2 = Fabricate(:video, title: 'Star Wars: Episode 2')
        bride_wars = Fabricate(:video, title: 'Bride Wars')
        star_trek = Fabricate(:video, title: 'Star Trek')
        refresh_index

        expect(Video.search('Star Wars').records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end

end