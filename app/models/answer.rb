class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  def best!
    unless self.best?
      transaction do
        question.best_answer&.update!(best: false)
        self.update!(best: true)
      end
    end
  end
end
