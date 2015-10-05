require 'spec_helper'

describe InvitationsController do

  let(:user) { Fabricate(:user) }

  context 'for signed-in user' do

    before do
      login_user user
    end

    describe 'GET :new' do
      it 'sets a new invitation linked to the current user' do
        get :new
        expect(assigns(:invitation)).to be_instance_of(Invitation)
        expect(assigns(:invitation).user).to eq user
      end
    end

    describe 'POST :create' do

      before do
        ActionMailer::Base.deliveries.clear
      end

      context 'for new persons' do

        before do
          post :create, invitation: Fabricate.attributes_for(:invitation, email: 'new-user@domain.com')
        end

        it 'creates a new invitation' do
          expect(Invitation.count).to be(1)
        end

        it 'creates a new invitation linked to the current user' do
          expect(Invitation.last.user).to eq user
        end

        it 'create a new invitation for the invited person' do
          expect(Invitation.last.email).to eq 'new-user@domain.com'
        end

        it 'sends an email to the invited person' do
          expect(ActionMailer::Base.deliveries.last.to).to include 'new-user@domain.com'
        end
      end

      context 'for persons already invited' do
        before do
          invitation_attrs = Fabricate.attributes_for(:invitation, user: user, email: 'invited-user@domain.com')
          post :create, invitation: invitation_attrs
          post :create, invitation: invitation_attrs
        end

        it 'does not create a new invitation' do
          expect(Invitation.count).to be 1
        end

        it 'resends the invitation email' do
          expect(ActionMailer::Base.deliveries.count).to be 2
          expect(ActionMailer::Base.deliveries.last.to).to include 'invited-user@domain.com'
        end
      end
    end

    describe 'GET :show' do
      let(:invitation) { Fabricate(:invitation, user: user) }

      it 'creates a new relationship between the inviting and the invited person' do
        get :show, token: invitation.token
        expect(user.followers.map(&:email)).to include invitation.email
      end
    end
  end

  context 'for non-authorized users' do
    it 'redirects to the sign-in page' do
      expect(response).to redirect_to sign_in_path
    end

    it 'sets a error message' do
      expect(flash[:danger]).to be
    end
  end

end