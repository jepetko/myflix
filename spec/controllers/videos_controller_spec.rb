require 'spec_helper'

describe VideosController do

  describe 'GET #show' do
    context 'for authenticated users' do
      before(:each) do
        user = Fabricate(:user)
        self.controller.login_user user
      end
      let(:video) { video = Fabricate(:video) }

      it 'assigns video instance variable' do
        get :show, id: video.id
        assigns(:video).should eq video
      end

      it 'assigns reviews instance variable' do
        review_1 = Fabricate(:review, video: video)
        review_2 = Fabricate(:review, video: video)
        get :show, id: video.id

        assigns(:reviews).should =~ [review_1, review_2]
        # another way to say it
        # expect(assigns(:reviews)).to match_array [review_1, review_2]
      end
    end

    context 'for not authenticated users' do
      it 'redirects to sign_in path' do
        get :show, id: 1
        response.should redirect_to sign_in_path
      end
    end
  end

  describe 'POST #search' do
    context 'for authenticated users' do
      before(:each) do
        user = Fabricate(:user)
        self.controller.login_user user
        10.times { Fabricate(:video) }
        Fabricate(:video, title: 'From dusk till down')
      end

      it 'assigns videos instance' do
        post :search, term: 'dusk'
        assigns(:videos).should be
      end
    end

    context 'for not authenticated users' do
      it 'redirects to sign_in path' do
        post :search, term: 'dusk'
        response.should redirect_to sign_in_path
      end
    end
  end
end