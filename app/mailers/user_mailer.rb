class UserMailer < ActionMailer::Base
  default from: "betamovies.yx.me@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm
    @greeting = "Hi"

    mail :to => "betamovies.yx.me@gmail.com", :subject => "testum"
  end
end
