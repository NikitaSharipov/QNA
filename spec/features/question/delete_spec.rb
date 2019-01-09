require 'rails_helper'

feature 'User can delete his question', %q{
  In order to to manage user's questions
  As an authenticated user
  I'd like to be able to delete my question
} do

  given(:user) { create :user }
  given(:another_user) { create :user }

  given!(:question) { create(:question, author: user) }
  given!(:another_question) { create(:question, author: another_user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'Authenricated user try to delet his question' do
      expect(page).to have_content question.title
      within(".question_title#{question.id}") { click_on 'Delete' }
      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario "Authenricated user try to delete other's user question" do
      within(".question_title#{another_question.id}") do
        expect(page).to have_content another_question.title
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
