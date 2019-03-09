class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable,
    :omniauthable, omniauth_providers: [:github, :facebook]

  has_many :authorizations, dependent: :destroy
  has_many :questions, foreign_key: :author_id, dependent: :nullify
  has_many :answers, foreign_key: :author_id, dependent: :nullify
  has_many :badges
  has_many :votes
  has_many :comments
  has_many :subscriptions, dependent: :destroy

  def author_of?(thing)
    id == thing.author_id
  end

  def self.find_for_oauth(auth, email)
    Services::FindForOauth.new(auth, email).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def add_facebook_name(facebook_name)
    self.facebook_name ||= facebook_name
  end

  def subscribed_to(question)
    subscriptions&.find_by(question: question)
  end
end
