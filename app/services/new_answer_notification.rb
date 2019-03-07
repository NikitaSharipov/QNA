class Services::NewAnswerNotification
  def send_question_updates(answer)
    subscribers = answer.question.subscribers

    subscribers.find_each(batch_size: 500) do |user|
      NewsNotificationMailer.notify(answer, user).deliver_later
    end
  end
end
