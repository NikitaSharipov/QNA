require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :body }
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
  it { should have_many(:comments).dependent(:destroy) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }

    it "mark answer as best" do
      answer.best!
      expect(answer).to be_best
    end

    describe 'best answer' do
      before do
        another_answer.best!
        answer.best!
        another_answer.reload
      end

      it 'turn best flag on new best answer on' do
        expect(answer).to be_best
      end

      it 'turn best flag on old best answer off' do
        expect(another_answer).not_to be_best
      end
    end

    describe 'badge' do
      let!(:badge) { create(:badge, question: question) }

      it 'awards badge to author of chosen answer' do
        answer.best!
        expect(badge.user).to eq user
      end

      it 'awards badge to chosen answer' do
        answer.best!
        expect(badge.answer).to eq answer
      end
    end

    describe Answer do
      it_behaves_like "Votable" do
        let(:user) { create(:user) }
        let(:another_user) { create :user }
        let(:question) { create(:question, author: user) }
        let(:votable) { create(:answer, question: question, author: user) }
      end

      it_behaves_like "Commentable" do
        let(:user) { create(:user) }
        let(:commentable) { create(:answer, question: question, author: user) }
      end
    end
  end
end
