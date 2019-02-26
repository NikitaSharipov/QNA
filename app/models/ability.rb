class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :create_comment, [Question, Answer]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id

    can [:vote_up, :vote_down, :cancel], [Question, Answer] do|votable|
      !user.author_of?(votable)
    end

    can :best, Answer, answer: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :index, BadgesController

    can :manage, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end
