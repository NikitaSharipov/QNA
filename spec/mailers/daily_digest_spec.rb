require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) {create_list(:question, 3, author: user)}
    let(:questions_titles) { questions.pluck(:title) }
    let(:mail) { DailyDigestMailer.digest(user, questions_titles) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

    it "consider questions list" do
      expect(mail.body.encoded).to match(questions_titles.to_s)
    end

  end

end
