require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

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
      end
    end

    scenario 'edit the question with attached file' do
      click_on 'Edit'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
      sleep 1

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his question with errors' do

      click_on 'Edit'

      within '.questions' do
        fill_in 'Your question title', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Title can't be blank"

    end

    describe 'with another user and question on page' do

      given!(:another_user) { create :user }
      given!(:another_question) { create(:question, author: another_user) }

      scenario "tries to edit other user's question" do
        visit questions_path
        within(".question_title#{another_question.id}") do
          expect(page).to have_content another_question.title
          expect(page).to_not have_link 'Edit'
        end
      end

    end

  end
end
