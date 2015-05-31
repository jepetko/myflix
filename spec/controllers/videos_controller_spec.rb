require 'spec_helper'

describe VideosController do

  describe 'GET #show' do
    context 'for authenticated users' do
      before(:each) do
        user = Fabricate(:user)
        login_user user
      end
      let(:video) { Fabricate(:video) }

      it 'assigns @video variable' do
        get :show, id: video.id
        expect(assigns(:video)).to eq video
      end

      it 'assigns @reviews variable' do
        review_1 = Fabricate(:review, video: video)
        review_2 = Fabricate(:review, video: video)
        get :show, id: video.id

        # assigns(:reviews).should =~ [review_1, review_2]
        # another way to say it
        expect(assigns(:reviews)).to match_array [review_1, review_2]
      end

      it 'assigns a @review variable' do
        get :show, id: video.id
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it 'assigns a @queue_item variable' do
        get :show, id: video.id
        expect(assigns(:queue_item)).to be_instance_of(QueueItem)
      end
    end

    context 'for not authenticated users' do
      it 'redirects to sign_in path' do
        get :show, id: 1
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'POST #search' do
    context 'for authenticated users' do
      before(:each) do
        user = Fabricate(:user)
        login_user user
        10.times { Fabricate(:video) }
        Fabricate(:video, title: 'From dusk till down')
      end

      it 'assigns videos instance' do
        post :search, term: 'dusk'
        expect(assigns(:videos)).to be
      end
    end

    context 'for not authenticated users' do
      it 'redirects to sign_in path' do
        post :search, term: 'dusk'
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end