class UserMailer < ActionMailer::Base
  default from: Settings.user_mailer.email

  def reset_password user, password
    I18n.locale = :en
    @user = user
    @user.password = password
    mail to: @user.email, subject: t(".subject")
  end
end
