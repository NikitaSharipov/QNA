require 'rails_helper'

RSpec.describe Services::SearchSphinxService do
  describe '.find' do
    it 'should return an array of all classes objects' do
      expect(ThinkingSphinx).to receive(:search).with('Test Search', page: 1, per_page: 3)
      subject.search('Global', 'Test Search', 1)
    end

    %w[User Question Answer Comment].each do |klass|
      it "should return an array of #{klass} class objects" do
        expect(klass.constantize).to receive(:search).with('Test Search', page: 1, per_page: 3)
        subject.search(klass, 'Test Search', 1)
      end
    end

    it 'should return false if Search Query is blank' do
      expect(subject.search('Global', '', 1)).to eq nil
    end

    it 'should return false if search category is wrong' do
      expect(subject.search('Wrong_Category', 'Test Search', 1)).to eq nil
    end
  end
end
