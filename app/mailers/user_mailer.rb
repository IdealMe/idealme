class UserMailer < ActionMailer::Base
  default from: "info@idealme.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @greeting = "Hi #{user.fullname}"

    mail to: "#{user.email}"
  end
end
