require 'spec_helper'

describe Review do

  it { should belong_to :video }
  it { should belong_to :user }
  it { should respond_to :content }
  it { should respond_to :rating }
  it { should validate_presence_of :content }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :video }

  let(:video) { Fabricate(:video) }

  context 'for rating values between 1 and 5' do
    it 'is valid' do
      (1..5).each do |rating|
        review = Fabricate.build(:review, rating: rating, video: video)
        expect(review).to be_valid
      end
    end
  end

  context 'for rating values out of 1 and 5' do
    it 'is invalid' do
      [-1,0,6].each do |rating|
        review = Fabricate.build(:review, rating: rating)
        expect(review).to_not be_valid
      end
    end

    it 'has error message' do
      [-1,0,6].each do |rating|
        review = Review.create Fabricate.attributes_for(:review, rating: rating)
        expect(review.errors[:rating]).to include('must be between 1 and 5')
      end
    end
  end
end