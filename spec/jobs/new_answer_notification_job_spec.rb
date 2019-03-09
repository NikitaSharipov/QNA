require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, author: user, question: question) }
  let(:service) { double('Service::NewAnswerNotification') }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#send_question_updates' do
    expect(service).to receive(:send_question_updates).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
