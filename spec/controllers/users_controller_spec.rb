require 'spec_helper'

describe UsersController do

  describe 'GET :new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    context 'token parameter provided' do

      let(:invitation) { Fabricate(:invitation) }
      before do
        get :new, token: invitation.token
      end

      it 'sets @token' do
        expect(assigns(:token)).to eq invitation.token
      end

      it 'fills @users with default values of the invited person' do
        user = assigns(:user)
        expect(user.email).to eq invitation.email
        expect(user.full_name).to eq invitation.full_name
      end

    end
  end

  describe 'POST :create' do

    let(:user_hash) { Fabricate.attributes_for(:user) }

    context 'sign up successful' do
      it 'redirects to the sign_in page' do
        sign_up_result = double(:sign_up_result, successful?: true, message: nil)
        expect_any_instance_of(SignUpService).to receive(:sign_up).and_return(sign_up_result)
        post :create, user: user_hash, stripeToken: 'token_123'
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'sign up failed' do
      before do
        sign_up_result = double(:sign_up_result, successful?: false, message: 'Your credit card was declined.')
        expect_any_instance_of(SignUpService).to receive(:sign_up).and_return(sign_up_result)
        post :create, user: user_hash, stripeToken: 'token_123'
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets an error message' do
        expect(flash[:danger]).to be
      end

      it 'sets the @user instance' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

  end

  describe 'GET :show' do
    let(:user) { Fabricate(:user) }

    before(:each) do
      login_user user
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