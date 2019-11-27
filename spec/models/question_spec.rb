require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe Question do
    it_behaves_like "Votable" do
      let(:user) { create(:user) }
      let(:another_user) { create :user }
      let(:votable) { create(:question, author: user) }
    end

    it_behaves_like "Commentable" do
      let(:user) { create(:user) }
      let(:commentable) { create(:question, author: user) }
    end
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, author: user) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe '#subscribers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'should get array of users' do
      expect(question.subscribers).to eq [user]
    end
  end
end
