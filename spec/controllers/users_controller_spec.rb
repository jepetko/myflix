require 'spec_helper'

describe UsersController do

  describe 'GET :new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST :create' do

    let(:user_hash) { user_hash = Fabricate.attributes_for(:user) }

    context 'user data correct' do

      before(:each) { post :create, user: user_hash }
      it 'creates a new user' do
        expect(User.count).to be(1)
        expect(User.last.email).to eq(user_hash[:email])
        expect(User.last.full_name).to eq(user_hash[:full_name])
      end
      it 'redirects to sign_in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'user data not correct' do
      before(:each) { post :create, user: user_hash.merge(password: '') }
      it 'does not create a new user' do
        expect(User.count).to be 0
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context 'email not already taken and password and password_confirmation don\'t match' do
      before(:each) { post :create, user: user_hash.merge(password_confirmation: '456') }
      it 'shows a hint regarding the password' do
        expect(assigns(:user).errors.full_messages).to include "Password confirmation doesn't match Password"
      end
    end

    context 'email is already taken' do
      before(:each) do
        post :create, user: user_hash
        post :create, user: user_hash.merge(email: User.last.email)
      end
      it 'shows a hint regarding the taken email' do
        expect(assigns(:user).errors.full_messages).to include 'Email has already been taken'
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET :show' do
    let(:user) { Fabricate(:user) }

    before(:each) do
      get :show, id: user.id
    end
    it 'renders the show template' do
      expect(response).to render_template :show
    end
    it 'sets the @user' do
      expect(assigns(:user)).to eq(user)
    end
  end

end