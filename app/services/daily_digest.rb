class Services::DailyDigest

  def send_digest
    questions = Question.where(created_at: (Time.now - 24.hours)..Time.now)
    questions_titles = questions.pluck(:title)

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions_titles).deliver_later
    end
  end

end
