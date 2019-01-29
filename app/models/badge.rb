class Badge < ApplicationRecord
  belongs_to :question, dependent: :destroy
  belongs_to :answer, optional: true
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true
end
