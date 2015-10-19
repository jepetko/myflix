require 'spec_helper'

describe Admin::VideosController do

  context 'for admin users' do
    before(:each) do
      admin = Fabricate(:admin)
      login_user admin
    end

    it 'sets @video variable' do
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
  end

  context 'for non-admin users' do
    before(:each) do
      non_admin = Fabricate(:user)
      login_user non_admin
    end

    it 'redirects to the home path' do
      get :new
      expect(response).to redirect_to(home_path)
    end

    it 'sets error message' do
      get :new
      expect(flash[:danger]).to be
    end
  end

end