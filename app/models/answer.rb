class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User'
  belongs_to :question

  validates :body, presence: true

  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many_attached :files
  has_one :badge

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  def best!
    unless self.best?
      transaction do
        question.badge.update!(user: question.author, answer: self) if question.badge
        question.best_answer&.update!(best: false)
        self.update!(best: true)
      end
    end
  end



end
