class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  # has_many :comments, dependent: :destroy, as: :commentable
  has_many_attached :files
  has_one :badge
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_commit :calculate_reputation
  after_commit :subscribe_for_updates, on: :create

  def best_answer
    answers.where(best: true).first
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_for_updates
    subscriptions.create(user: author)
  end
end
