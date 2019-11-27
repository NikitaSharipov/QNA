require 'rails_helper'

feature 'User can delete the file attached to the question', "
  As an author of question
  I'd like to be able to delete the file attached to my question
" do
  given!(:user) { create(:user) }
  given(:another_user) { create :user }

  given!(:question) { create(:question, :with_file, author: user) }
  given!(:another_question) { create(:question, :with_file, author: another_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'author tries to delete the file to his question' do
      visit question_path(question)
      click_on 'Delete file'
      expect(page).not_to have_link 'rails_helper.rb'
    end

    scenario "user tries to delete the file to another user's question" do
      visit question_path(another_question)
      expect(page).not_to have_link 'Delete file'
    end
  end
end
