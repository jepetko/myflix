require 'spec_helper'

describe VideosController do

  describe 'GET #show' do
    context 'for authenticated users' do
      before(:each) do
        user = Fabricate(:user)
        self.controller.login_user user
      end
      let(:video) { video = Video.create(title: 'Family Guy', description: 'cool video') }

      it 'assigns video instance' do
        get :show, id: video.id
        assigns(:video).should eq video
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