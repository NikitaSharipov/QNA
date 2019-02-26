require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    let(:question) { create :question, author: user }
    let(:other_question) { create :question, author: other}

    let(:answer) { create :answer, author: user, question: question }
    let(:other_answer) { create :answer, author: other, question: question }

    let(:link) { create :link, linkable: question }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :create_comment, Question }
    it { should be_able_to :create_comment, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :vote_up, other_question }
    it { should be_able_to :vote_down, other_question }
    it { should be_able_to :cancel, other_question }

    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :vote_up, other_answer }
    it { should be_able_to :vote_down, other_answer }
    it { should be_able_to :cancel, other_answer }

    it { should_not be_able_to :vote_up, answer }
    it { should_not be_able_to :vote_down, answer }

    it { should be_able_to :best, Answer }


    it { should be_able_to :destroy, link }

    it { should be_able_to :index, BadgesController }
    it { should be_able_to :manage, ActiveStorage::Attachment }

  end

end
