require 'spec_helper'

describe VideoDecorator do

  it 'responds to methods which a Video instance responds to' do
    decorator = Video.new.decorate
    expect(decorator).to respond_to(:category)
    expect(decorator).to respond_to(:reviews)
  end

  it 'responds to method :total_rating' do
    decorator = Video.new.decorate
    expect(decorator).to respond_to(:total_rating)
  end

  describe '#total_rating' do

    context 'for video with ratings' do
      it 'returns the average rating value / 5.0' do
        video = Fabricate(:video)
        Fabricate(:review, rating: 2, video: video)
        Fabricate(:review, rating: 3, video: video)
        expect(video.decorate.total_rating).to eq '2.5 / 5.0'
      end
    end

    context 'for video without ratings' do
      it 'returns N/A' do
        video = Fabricate(:video)
        expect(video.decorate.total_rating).to eq 'N/A'
      end
    end
  end

end