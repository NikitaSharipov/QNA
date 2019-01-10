require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'method author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:another_user) { create(:user) }
    let(:foreign_question) { create(:question, author: another_user) }

    it "it is user's question" do
      expect(user).to be_author_of(question)
    end

    it "it is not user's question" do
      expect(user).not_to be_author_of(foreign_question)
    end
  end
end
