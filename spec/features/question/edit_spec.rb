require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given(:another_user) { create :user }

  given!(:question) { create(:question, author: user) }
  given!(:another_question) { create(:question, author: another_user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true  do

    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'edits his question' do

      click_on 'Edit'

      within '.questions' do

        fill_in 'Your question title', with: 'edited question title'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do

      click_on 'Edit'

      within '.questions' do
        fill_in 'Your question title', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Title can't be blank"

    end

    scenario "tries to edit other user's question" do

      within(".question_title#{another_question.id}") do
        expect(page).to have_content another_question.title
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
