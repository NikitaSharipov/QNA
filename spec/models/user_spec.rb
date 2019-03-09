require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:email) { nil }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth, email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth, email)
    end
  end

  describe '#subscribed_to' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it 'should get subscription entry' do
      expect(user.subscribed_to(question)).to eq Subscription.last
    end
  end
end
