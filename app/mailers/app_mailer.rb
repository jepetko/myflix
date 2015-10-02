class AppMailer < ActionMailer::Base

  def send_mail(to, subject)
    mail from: 'admin@myflix.com', to: to, subject: subject
  end

  def send_mail_on_register(user)
    @user = user
    send_mail user, 'You have registered successfully!'
  end

end