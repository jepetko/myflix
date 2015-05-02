require 'spec_helper'

describe ReviewsController do

  describe 'POST :create' do

    let(:video) { video = Fabricate(:video) }

    context 'user is authorized' do
      let(:user) { user = Fabricate(:user) }
      before do
        self.controller.login_user user
      end

      context 'review data is valid' do
        before do
          post :create, video_id: video, review: Fabricate.attributes_for(:review)
        end
        it 'creates a new review' do
          expect(Review.count).to eq 1
        end
        it 'creates a new review associated with the video' do
          expect(Review.last.video).to eq video
        end
        it 'creates a new review associated with the signed in user' do
          expect(Review.last.user).to eq user
        end
        it 'sets the notice' do
          expect(flash[:notice]).to eq 'Review posted successfully.'
        end
        it 'redirects to the video page' do
          expect(response).to redirect_to video_path(video)
        end
      end

      context 'review data is not valid' do
        let!(:review_1) { review_1 = Fabricate(:review, video: video) }
        before do
          post :create, video_id: video, review: { rating: 5 }
        end
        it 'does not create a new review' do
          expect(Review.count).to eq 0
        end
        it 'sets the error message' do
          expect(flash[:error]).to eq 'Review not saved.'
        end
        it 'renders the video show template' do
          expect(response).to render_template 'videos/show'
        end
        it 'sets the @video variable' do
          expect(assigns(:video)).to eq video
        end
        it 'sets the @reviews variable' do
          expect(assigns(:reviews)).to match_array [review_1]
        end
        it 'sets the @review variable' do
          expect(assigns(:review)).to be_instance_of(Review)
        end
      end
    end

    context 'user is unauthorized' do
      before do
        post :create, video_id: video, review: Fabricate.attributes_for(:review)
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