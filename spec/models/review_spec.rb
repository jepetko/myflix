require 'spec_helper'

describe Review do

  it { should belong_to :video }
  it { should respond_to :comment }
  it { should respond_to :rating }
  it { should validate_presence_of :comment }
  it { should validate_presence_of :rating }

  context 'for rating values between 0 and 5' do
    it 'is valid' do
      (0..5).each do |rating|
        review = Fabricate.build(:review, rating: rating)
        expect(review).to be_valid
      end
    end
  end

  context 'for rating values out of 0 and 5' do
    it 'is invalid' do
      [-1,6].each do |rating|
        review = Fabricate.build(:review, rating: rating)
        expect(review).to_not be_valid
      end
    end

    it 'has error message' do
      [-1,6].each do |rating|
        review = Review.create Fabricate.attributes_for(:review, rating: rating)
        expect(review.errors[:rating]).to include('must be between 0 and 5')
      end
    end
  end
end