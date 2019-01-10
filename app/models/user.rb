class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: :author_id, dependent: :nullify
  has_many :answers, foreign_key: :author_id, dependent: :nullify

  def author_of?(thing)
    id == thing.author_id
  end

end
