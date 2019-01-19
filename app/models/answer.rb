class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  def best!
    unless self.best?
      transaction do
        question.best_answer&.update!(best: false)
        self.update!(best: true)
      end
    end
  end
end
