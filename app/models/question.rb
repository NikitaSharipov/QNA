class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def best_answer
    self.answers.where(best: true).first
  end
end
