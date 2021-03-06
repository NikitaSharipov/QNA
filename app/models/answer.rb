class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'
  belongs_to :question, touch: true

  validates :body, presence: true

  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  # has_many :comments, dependent: :destroy, as: :commentable
  has_many_attached :files
  has_one :badge

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  after_commit :send_notification, on: :create

  def best!
    unless best?
      transaction do
        question.badge&.update!(user: question.author, answer: self)
        question.best_answer&.update!(best: false)
        update!(best: true)
      end
    end
  end

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(self)
  end
end
