require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to solve problems
  As an user
  I'd like to be able to view all questions from a community
} do
  given(:user) { create :user }
  given!(:question) { create(:question, author: user) }
  given!(:questions) { create_list :question, 3, author: user }

  scenario 'User tries to see a question list' do
    visit questions_path
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'User tries to see question' do
    visit questions_path
    within(".question_title#{question.id}") { click_on 'Show' }
    expect(page).to have_content question.title
  end
end
