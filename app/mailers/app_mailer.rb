class AppMailer < ActionMailer::Base

  def send_mail(to, subject)
    mail from: 'admin@myflix.com', to: to.email, subject: subject
  end

  def send_mail_on_register(user)
    @user = user
    send_mail user, 'You have registered successfully!'
  end

  def send_mail_on_reset_password(user)
    @user = user
    @link = reset_password_url(user.reset_password_token, default_url_options)
    send_mail user, 'Reset your password now'
  end

  private

  def default_url_options
    if Rails.env.production?
      {:host => 'leanetic-myflix.herokuapp.com'}
    else
      {:host => 'localhost', port: 3000}
    end
  end

end