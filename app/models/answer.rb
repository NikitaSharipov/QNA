class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  def mark_best
    self.update!(best: true)
  end

  def chose_best
    question.answers.where(best: true).first
  end

  def best!
    if self.best != true
      best_answer = chose_best
      best_answer&.update!(best: false)
      mark_best
    end
  end
end
