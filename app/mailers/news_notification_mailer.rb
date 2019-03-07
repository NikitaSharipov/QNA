class NewsNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.news_notification_mailer.notify.subject
  #
  def notify(answer, user)
    @answer = answer

    mail to: user.email
  end
end
