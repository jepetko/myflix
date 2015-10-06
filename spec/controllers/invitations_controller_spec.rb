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

        it 'redirects to the new template' do
          expect(response).to redirect_to new_invitation_path
        end

        it 'sets the success message' do
          expect(flash[:success]).to be
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

      context 'for invalid invitations' do
        before do
          invalid_invitation_attrs = Fabricate.attributes_for(:invitation, user: user, email: '')
          post :create, invitation: invalid_invitation_attrs
        end
        it 'renders the new template' do
          expect(response).to render_template 'invitations/new'
        end
        it 'sets the error message' do
          expect(flash[:danger]).to be
        end
        it 'does not send an email' do
          expect(ActionMailer::Base.deliveries.count).to be 0
        end
      end
    end

    describe 'GET :show' do
      let(:invitation) { Fabricate(:invitation, user: user) }

      it 'redirects to the register form' do
        get :show, token: invitation.token
        expect(response).to redirect_to register_path(token: invitation.token)
      end
    end
  end

  context 'for non-authorized users' do

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
    end

    it_behaves_like 'requires sign in' do
      invitation = Fabricate(:invitation)
      let(:action) { get :show, token: invitation.token }
    end

  end

end