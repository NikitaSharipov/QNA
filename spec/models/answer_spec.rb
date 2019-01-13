require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of :body }

  describe 'best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }

    it "mark answer as best" do
      answer.mark_best
      expect(answer.best).to be true
    end

    it 'only one answer must be best' do
      another_answer.mark_best

      answer.best!
      another_answer.reload

      expect(answer.best).to be true
      expect(another_answer.best).to be false
    end
  end
end
