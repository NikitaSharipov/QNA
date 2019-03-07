# Preview all emails at http://localhost:3000/rails/mailers/news_notification
class NewsNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/news_notification/notify
  def notify
    NewsNotificationMailer.notify
  end

end
