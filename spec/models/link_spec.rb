require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'gist methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:link, :gist, linkable: question) }

    it 'check if link gist' do
      expect(link.gist?).to be false
      expect(gist_link.gist?).to be true
    end

    it "show gist's content" do
      expect(gist_link.gist_content).to eq('usual')
    end
  end
end
