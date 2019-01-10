require 'rails_helper'

feature 'User can view the question and answers to it', %q{
  In order to solve problem
  As an user
  I'd like to view the question and answers to it
} do
  given(:user) { create :user }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario 'View the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'View the answers to question' do
    visit question_path(question)
    answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end
