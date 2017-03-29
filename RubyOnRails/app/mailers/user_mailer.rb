class UserMailer < ActionMailer::Base
  default from: "no-reply@caidianying.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => 'Welcome')
  end

  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => (t :reset_password))
  end
end
