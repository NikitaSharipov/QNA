class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:github]

  has_many :authorizations, dependent: :destroy
  has_many :questions, foreign_key: :author_id, dependent: :nullify
  has_many :answers, foreign_key: :author_id, dependent: :nullify
  has_many :badges
  has_many :votes
  has_many :comments

  def author_of?(thing)
    id == thing.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
