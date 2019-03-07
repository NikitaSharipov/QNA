class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user_id, uniqueness: { scope: :question_id }
end
