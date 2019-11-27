require "rails_helper"

RSpec.describe NewsNotificationMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:mail) { NewsNotificationMailer.notify(answer, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
