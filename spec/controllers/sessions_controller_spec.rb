require 'spec_helper'

describe SessionsController do

  describe 'GET :new' do
    context 'user is already logged-in' do
      it 'redirects to the home_path' do
        user = Fabricate(:user)
        login_user user
        get :new
        expect(response).to redirect_to home_path
      end
    end
  end

  describe 'POST :create' do
    let(:user) { Fabricate(:user, password: '123', password_confirmation: '123') }

    context 'user credentials are correct' do
      before do
        post :create, email: user.email, password: user.password
      end
      it 'puts users id into the session' do
        expect(session[:user_id]).to eq user.id
      end
      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
      end
      it 'sets the notice' do
        expect(flash[:notice]).to eq('You are logged in. Enjoy!')
      end
    end

    context 'user credentials are not correct' do
      before do
        post :create, email: user.email, password: 'wrong'
      end
      it 'does not put the user id into the session' do
        expect(session[:user_id]).to be_nil
      end
      it 'renders the :new template' do
        expect(response).to render_template :new
      end
      it 'sets the error message' do
        expect(flash[:error]).to be
      end
    end
  end

  describe 'DELETE :destroy' do
    before do
      session[:user_id] = Fabricate(:user).id
      delete :destroy
    end

    it 'removes user_id from the session' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to root_path
    end

    it 'sets the notice' do
      expect(flash[:notice]).to be
    end
  end

end