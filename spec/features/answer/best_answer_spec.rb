require 'rails_helper'

feature 'Question author can chose the best answer', "
  In order to thank the respondent
  As an question author
  I'd like to be able to chose the best answer
" do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given!(:another_question) { create(:question, author: another_user) }

  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:another_answer) { create(:answer, question: question, author: user) }

  scenario 'Not author can not chose best answer' do
    sign_in(user)

    visit question_path(another_question)
    expect(page).to_not have_link 'Mark as best'
  end

  scenario 'Unauthenticated can not chose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'mark best answer' do
      within(".answer_title#{answer.id}") do
        expect(page).not_to have_content 'Best answer!'
        click_on 'Mark as best'
        expect(page).to have_content "Best answer!"
      end
    end

    scenario 'chose another best answer', js: true do
      within(".answer_title#{answer.id}") do
        expect(page).not_to have_content 'Best answer!'
        click_on 'Mark as best'
        expect(page).to have_content "Best answer!"
      end
      within(".answer_title#{another_answer.id}") do
        click_on 'Mark as best'
        expect(page).to have_content "Best answer!"
      end
      within(".answer_title#{answer.id}") do
        expect(page).not_to have_content "Best answer!"
      end
    end

    scenario 'the best answer always must be first', js: true do
      within all('.answer').first { expect(page).to have_content answer.body }

      within(".answer_title#{answer.id}") { click_on 'Mark as best' }
      within all('.answer').first { expect(page).to have_content answer.body }

      within(".answer_title#{another_answer.id}") { click_on 'Mark as best' }
      within all('.answer').first { expect(page).to have_content another_answer.body }
    end
  end
end
