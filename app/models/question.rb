class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  #has_many :comments, dependent: :destroy, as: :commentable
  has_many_attached :files
  has_one :badge

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    self.answers.where(best: true).first
  end

end
