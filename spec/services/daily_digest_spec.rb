require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) {create_list(:user, 3)}
  let(:questions) { create_list(:question, 3, author: users.first) }
  let(:questions_titles) { questions.pluck(:title) }

  it 'sends daily digest to all users' do
    users.each {|user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_titles).and_call_original}
    subject.send_digest
  end
end
