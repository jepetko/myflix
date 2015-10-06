class AppMailer < ActionMailer::Base

  default from: 'admin@myflix.com'

  def send_mail_on_register(user)
    @user = user
    mail to: user.email, subject: 'You have registered successfully!'
  end

  def send_mail_on_reset_password(user)
    @user = user
    @link = reset_password_url(user.reset_password_token, Rails.application.config.action_mailer.default_url_options)
    mail to: user.email, subject: 'Reset your password now'
  end

  def send_mail_on_invite(invitation)
    @invitation = invitation
    @link = confirm_invitation_url(invitation.token, Rails.application.config.action_mailer.default_url_options)
    mail to: invitation.email, subject: 'You are invited to use myflix!'
  end

end