require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to to manage user's answer
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create :user }
  given(:another_user) { create :user }

  given!(:question) { create(:question, author: user) }

  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:another_answer) { create(:answer, question: question, author: another_user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenricated user try to delet his answer' do
      expect(page).to have_content answer.body
      within(".answer_title#{answer.id}") { click_on 'Delete' }
      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "Authenricated user try to delete other's user answer" do
      expect(page).to have_content answer.body
      within(".answer_title#{another_answer.id}") { click_on 'Delete' }
      expect(page).to have_content "You can not delete another user's answer"
      expect(page).to have_content another_answer.body
    end
  end
end
