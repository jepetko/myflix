require 'spec_helper'

describe PasswordsController do
  render_views
  let(:user) { Fabricate(:user) }
  let(:forgetful_user) { Fabricate(:user, reset_password_token: SecureRandom.urlsafe_base64) }
  let(:token) { SecureRandom.urlsafe_base64 }

  # shows the form the email address of the user should be inserted into
  describe 'GET :new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  # creates a token and sends it to the user via email
  describe 'POST :create' do

    before do
      post :create, email: user.email
      user.reload
    end

    it 'creates a password reset token' do
      expect(user.reset_password_token).to be
    end

    it 'sends an email to the proper user' do
      expect(ActionMailer::Base.deliveries.last.to).to include user.email
    end

    it 'sends an email to the user which contains a reset password link' do
      link = reset_password_path(token: user.reset_password_token)
      expect(ActionMailer::Base.deliveries.last.body).to include link
    end

    it 'expects to render confirm template' do
      expect(response).to render_template('passwords/confirm')
    end
  end

  # shows the user the form for new password creation
  describe 'GET :edit' do

    context 'for valid reset password tokens' do

      it 'renders the edit template' do
        get :edit, token: forgetful_user.reset_password_token
        expect(response).to render_template('passwords/edit')
      end

    end

    context 'for expired reset password tokens' do

      it 'shows an error message' do
        get :edit, token: token
        expect(response.body).to include('Your reset password link is expired')
      end

    end
  end

  # sets the new password and removes the random token from the database
  describe 'PUT :update' do

    context 'for valid password and password reset token' do

      let!(:old_password_digest) { forgetful_user.password_digest }
      before do
        put :update, token: forgetful_user.reset_password_token, password: 'newStart123'
        forgetful_user.reload
      end

      it 'resets the password' do
        expect(forgetful_user.password_digest).not_to eq old_password_digest
      end

      it 'removes the token' do
        expect(forgetful_user.reset_password_token).to be_nil
      end

      it 'redirects to the sign_in path' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'for invalid password reset token' do

      before do
        put :update, token: token, password: 'newStart123'
      end

      it 'redirects to the reset password form' do
        expect(response).to redirect_to reset_password_path(token)
      end

      it 'sets the error message' do
        expect(flash).to be
      end
    end
  end

end