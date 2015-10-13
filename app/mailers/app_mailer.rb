require 'mailgun'

class AppMailer < ActionMailer::Base

  default from: 'admin@myflix.com'

  module SimpleMailer
    def send_mail(params)
      mail(params).deliver
    end
  end

  module MailgunMailer
    def self.included(klass)
      klass.extend StaticReferences
    end

    def send_mail(params)
      mail_instance = mail params
      message_params = { from: AppMailer.default_params[:from], to: params[:to], subject: params[:subject], html: mail_instance.body.encoded }
      AppMailer.get_client.send_message Rails.application.secrets.mail_domain, message_params
    end

    module StaticReferences
      def get_client
        @@mail_client ||= Mailgun::Client.new(Rails.application.secrets.mail_api_key)
      end
    end
  end

  if Rails.application.secrets.mail_api_key
    include MailgunMailer
  else
    include SimpleMailer
  end


  def send_mail_on_register(user)
    @user = user
    send_mail to: user.email, subject: 'You have registered successfully!'
  end

  def send_mail_on_reset_password(user)
    @user = user
    @link = reset_password_url(user.reset_password_token, Rails.application.config.action_mailer.default_url_options)
    send_mail to: user.email, subject: 'Reset your password now'
  end

  def send_mail_on_invite(invitation)
    @invitation = invitation
    @link = confirm_invitation_url(invitation.token, Rails.application.config.action_mailer.default_url_options)
    send_mail to: invitation.email, subject: 'You are invited to use myflix!'
  end

end