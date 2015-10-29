class SignUpService

  attr_reader :state
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def successful?
    @state == :success
  end

  def sign_up(options = {})
    if @user.valid?
      @response = StripeWrapper::Customer.create(source: options[:stripeToken], user: @user)
      if @response.successful?
        @user.stripe_id = @response.customer_id
        @user.save
        AppMailer.delay.send_mail_on_register(@user.id)
        @message = 'You have been charged successfully. An email has been sent to your email. Enjoy Myflix!'
        @state = :success
        accept_invitation options[:token]
      else
        @message = @response.error_message
        @state = :failure
      end
    else
      @state = :failure
    end
    self
  end

  private

  def accept_invitation(token)
    return if !token
    invitation = Invitation.find_by(token: token)
    if invitation
      @user.follow invitation.user
      invitation.destroy
    end
  end

end