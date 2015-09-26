require 'spec_helper'

describe RelationshipsController do

  let(:user) { Fabricate(:user) }
  let(:another_user_1) { Fabricate(:user, full_name: 'VIP person 1') }
  let(:another_user_2) { Fabricate(:user, full_name: 'VIP person 2') }

  before(:each) do
    login_user user
  end

  describe 'POST :create' do
    before(:each) do
      post :create, id: another_user_1.id
    end

    it 'renders a message' do
      expect(flash[:message]).to be
    end

    it 'redirects to the show page' do
      expect(response).to redirect_to user_path(user)
    end

    it 'creates the relationship' do
      expect(current_user.followed_users).to include(another_user_1)
    end
  end

  describe 'GET :index' do
    before(:each) do
      user.follow another_user_1
      user.follow another_user_2
      get :index
    end

    it 'renders the people template' do
      expect(response).to render_template 'relationships/index'
    end

    it 'sets the @followed_users' do
      expect(assigns(:followed_users)).to eq([another_user_1, another_user_2])
    end
  end

  describe 'DELETE :destroy' do
    before(:each) do
      user.follow another_user_1
    end

    it 'renders the people template' do
      delete :destroy, id: another_user_1.id
      expect(response).to redirect_to user_path(user)
    end

    it 'sets the flash message' do
      delete :destroy, id: another_user_1.id
      expect(flash[:message]).to be
    end

    it 'removes the relationship' do
      expect(current_user.followed_users).to include(another_user_1)
      delete :destroy, id: another_user_1.id
      expect(current_user.followed_users).not_to include(another_user_1)
    end
  end
end