module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create(user: user, value: 1) unless user.author_of?(self) || voted?(user)
  end

  def vote_down(user)
    votes.create(user: user, value: -1) unless user.author_of?(self) || voted?(user)
  end

  def voted?(user)
    !!self.votes.where(user_id: user).first
  end

  def rating
    votes.sum(:value)
  end

  def cancel(user)
    votes.find_by(user_id: user.id).destroy
  end
end
