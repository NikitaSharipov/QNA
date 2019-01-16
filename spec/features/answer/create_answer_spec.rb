require 'rails_helper'

feature 'User can answer the question', %q{
  In order to solve other user's problem
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenricated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer!'

      expect(page).to have_content 'text text text'

      expect(page).to have_field("answer_body", :with => "")
    end

    scenario 'answer the question with errors' do
      click_on 'Answer!'
      expect(page).to have_content "Body can't be blank"
    end

  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer!'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
