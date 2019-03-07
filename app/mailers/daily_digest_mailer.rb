class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user, questions_titles)
    @greeting = "Hi"
    @questions_titles = questions_titles

    mail to: user.email
  end
end
