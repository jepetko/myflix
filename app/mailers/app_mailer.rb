class AppMailer < ActionMailer::Base

  default from: 'admin@myflix.com'

  def send_mail_on_register(user_id)
    @user = User.find(user_id)
    mail to: filter_recipients(@user.email), subject: 'You have registered successfully!'
  end

  def send_mail_on_reset_password(user_id)
    @user = User.find(user_id)
    @link = reset_password_url(@user.reset_password_token, Rails.application.config.action_mailer.default_url_options)
    mail to: filter_recipients(@user.email), subject: 'Reset your password now'
  end

  def send_mail_on_invite(invitation_id, message)
    @invitation = Invitation.find(invitation_id)
    @invitation.message = message
    @link = confirm_invitation_url(@invitation.token, Rails.application.config.action_mailer.default_url_options)
    mail to: filter_recipients(@invitation.email), subject: 'You are invited to use myflix!'
  end

  def send_mail_on_charge_failed(user_id)
    @user = User.find(user_id)
    mail to: filter_recipients(@user.email), subject: 'Your myflix subscription payment failed!'
  end

  private

  def filter_recipients(recipients)
    Rails.env.staging? ? Rails.application.secrets.mail_recipient : recipients
  end

end