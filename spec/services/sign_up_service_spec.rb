require 'spec_helper'

describe SignUpService, :vcr do

  let(:user_attrs) { Fabricate.attributes_for(:user) }
  before do
    ActionMailer::Base.deliveries.clear
  end

  context 'user data correct and credit card correct' do

    include_context 'stripe customer creation submitted'
    let!(:sign_up_service) do
      user = User.new user_attrs
      SignUpService.new(user).sign_up(stripeToken: 'token_123')
    end

    it 'is successful' do
      expect(sign_up_service.successful?).to be(true)
    end

    it 'sets the message' do
      expect(sign_up_service.message).to eq 'You have been charged successfully. An email has been sent to your email. Enjoy Myflix!'
    end

    it 'creates a new user' do
      expect(User.count).to be(1)
      expect(User.last.email).to eq(user_attrs[:email])
      expect(User.last.full_name).to eq(user_attrs[:full_name])
    end

    it 'sends a confirmation mail containing the right message' do
      expect(ActionMailer::Base.deliveries.last.body).to include(ERB::Util.html_escape_once(User.last.full_name))
    end

    it 'sends a confirmation mail to the right recipient' do
      expect(ActionMailer::Base.deliveries.last.to).to include(User.last.email)
    end
  end

  context 'user data correct and credit card declined' do

    include_context 'stripe customer creation submitted' do
      let(:success) { false }
      let(:error_message) { 'Your card was declined.' }
      let(:customer_id) { 'cus_abc123' }
    end

    let!(:sign_up_service) do
      user = User.new user_attrs
      SignUpService.new(user).sign_up(stripeToken: 'token_123')
    end

    it 'is not successful' do
      expect(sign_up_service.successful?).to be(false)
    end

    it 'sets the message' do
      expect(sign_up_service.message).to eq 'Your card was declined.'
    end

    it 'does not create a new user' do
      expect(User.count).to be 0
    end

    it 'does not send a confirmation email' do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end

  context 'user data not correct' do

    include_context 'stripe customer creation not submitted'

    let!(:sign_up_service) do
      user = User.new user_attrs.merge(password: '')
      SignUpService.new(user).sign_up(stripeToken: 'token_123')
    end

    it 'is not successful' do
      expect(sign_up_service.successful?).to be(false)
    end
    it 'does not create a new user' do
      expect(User.count).to be 0
    end
    it 'does not send a confirmation email' do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
    it 'does not charge the credit card' do
      expect(StripeWrapper::Customer).not_to have_received(:create)
    end
  end

  context 'invitation token provided' do

    include_context 'stripe customer creation submitted'
    let(:inviting_user) { Fabricate(:user) }
    let(:invitation) { Fabricate(:invitation, user: inviting_user, email: user_attrs[:email]) }
    let!(:sign_up_service) do
      user = User.new user_attrs
      SignUpService.new(user).sign_up(stripeToken: 'token_123', token: invitation.token)
    end

    it 'is successful' do
      expect(sign_up_service.successful?).to be(true)
    end

    it 'creates a new relationship between the inviting and the invited person' do
      expect(inviting_user.followers.map(&:email)).to include invitation.email
    end

    it 'destroys the invitation' do
      expect(Invitation.where(token: invitation.token).count).to be 0
    end
  end

end