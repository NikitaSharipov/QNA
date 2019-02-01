require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'vote methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'create vote with value 1' do
      question.vote_up(user)

      expect(question.votes.where(user: user).first.value).to eq 1
    end

    it 'create vote with value -1' do
      question.vote_down(user)

      expect(question.votes.where(user: user).first.value).to eq -1
    end

  end

end
