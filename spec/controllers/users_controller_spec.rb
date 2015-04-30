require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe 'POST create' do

    let(:user_hash) { user_hash = {email: Faker::Internet.email, full_name: Faker::Name.name, password: '123', password_confirmation: '123'} }

    context 'email not already taken and password and password_confirmation match' do

      before(:each) { post :create, user: user_hash }
      it 'creates a new user' do
        expect(User.last.email).to eq(user_hash[:email])
        expect(User.last.full_name).to eq(user_hash[:full_name])
      end
      it 'redirects to sign_in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'email not already taken and password and password_confirmation don\'t match' do
      before(:each) { post :create, user: user_hash.merge(password_confirmation: '456') }
      it 'shows a hint regarding the password' do
        expect(assigns(:user).errors.full_messages).to include "Password confirmation doesn't match the password"
      end
      it 'renders the new template' do
        expect(response).to render_template :new
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
end