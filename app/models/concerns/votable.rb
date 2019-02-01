module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create(user: user, value: 1) unless user.author_of?(self)
  end

  def vote_down(user)
    votes.create(user: user, value: -1) unless user.author_of?(self)
  end
end
