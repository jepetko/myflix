require 'spec_helper'

describe VideosController do

  before(:each) do
    user = User.create(email: 'user@someone.io', full_name: 'James Dean', password: '123', password_confirmation: '123')
    self.controller.login_user user
  end

  describe 'GET #show' do
    let(:video) { video = Video.create(title: 'Family Guy', description: 'cool video') }

    it 'assigns video instance' do
      get :show, id: video.id
      assigns(:video).should eq video
    end

    it 'renders template :show' do
      get :show, id: video.id
      response.should render_template :show
    end
  end

  describe 'POST #search' do

    before(:each) do
      10.times { Fabricate(:video) }
    end

    it 'assigns videos instance' do
      post :search, term: 'a'
      assigns(:videos).should be
    end

    it 'renders template :search' do
      post :search, term: 'a'
      response.should render_template :search
    end
  end
end