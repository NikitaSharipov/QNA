require 'rails_helper'

feature 'User can delete the file attached to the answer', "
  As an author of question
  I'd like to be able to delete the file attached to my answer
" do
  given!(:user) { create(:user) }
  given(:another_user) { create :user }

  given!(:question) { create(:question, author: user) }

  given!(:answer) { create(:answer, :with_file, question: question, author: user) }
  given!(:another_answer) { create(:answer, :with_file, question: question, author: another_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author tries to delete the file to his answer' do
      within(".answer_title#{answer.id}") do
        click_on 'Delete file'
        expect(page).not_to have_link 'rails_helper.rb'
      end
    end

    scenario 'user tries to delete the file to not his answer' do
      within(".answer_title#{another_answer.id}") do
        expect(page).not_to have_link 'Delete file'
      end
    end
  end
end
