require 'spec_helper'

describe ReviewsController do

  describe 'POST :create' do

    let(:user) { user = Fabricate(:user) }
    let(:video) { video = Fabricate(:video) }

    context 'user is authorized' do
      before do
        self.controller.login_user user
      end

      context 'review data is valid' do
        before do
          post :create, review: Fabricate.attributes_for(:review, video: video, user: user)
        end
        it 'creates a new review' do
          expect(Review.count).to eq 1
        end
        it 'sets the notice' do
          expect(flash[:notice]).to eq 'Review posted successfully.'
        end
        it 'redirects to the video page' do
          expect(response).to redirect_to video_path(video)
        end
      end

      context 'review data is not valid' do
        before do
          post :create, review: Fabricate.attributes_for(:review, content: '', video: video, user: user)
        end
        it 'does not create a new review' do
          expect(Review.count).to eq 0
        end
        it 'sets the error message' do
          expect(flash[:error]).to eq 'Review not saved.'
        end
        it 'renders the video page' do
          expect(response).to render_template 'videos/show'
        end
      end
    end

    context 'user is unauthorized' do
      before do
        post :create, review: Fabricate.attributes_for(:review, video: video, user: user)
      end
      it 'does not create a new review' do
        expect(Review.count).to eq 0
      end
      it 'redirects to the sign_in page' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end