require 'spec_helper'

describe SessionsController do
  let(:user) { user = Fabricate(:user, password: '123', password_confirmation: '123') }

  context 'user credentials correct' do
    it 'creates a new session with user id' do
      post :create, email: user.email, password: '123'
      expect(session[:user_id]).to be user.id
    end
    it 'redirects to the home path' do
      post :create, email: user.email, password: '123'
      expect(response).to redirect_to home_path
    end
  end

  context 'user credentials not correct' do

    it 'doesnt create a session with user id' do
      post :create, email: user.email, password: 'wrong'
      expect(session[:user_id]).to be_nil
    end
    it 'shows the error message and renders the :new template' do
      post :create, email: user.email, password: 'wrong'
      expect(flash[:error]).to eq('Your login credentials are invalid.')
      expect(response).to render_template :new
    end
  end

end