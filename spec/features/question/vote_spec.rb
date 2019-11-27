require 'rails_helper'

feature 'User can vote for the question', "
  In order to emphasize the question
  As an user
  I'd like to vote for question
" do
  given!(:user) { create :user }
  given!(:question) { create(:question, author: user) }

  scenario 'Vote for his question' do
    sign_in(user)
    visit questions_path
    expect(page).to_not have_link 'Vote up'
  end

  describe "User vote for another user's question" do
    given(:another_user) { create :user }

    background do
      sign_in(another_user)
      visit questions_path
    end

    scenario 'Vote up for question', js: true do
      click_on 'Vote up'
      expect(page).to have_content 'Voted with value 1'
    end

    scenario 'Vote down for question', js: true do
      click_on 'Vote down'
      expect(page).to have_content 'Voted with value -1'
    end

    scenario 'Vote for question', js: true do
      click_on 'Vote up'
      expect(page).to have_content 'Cancel'
    end

    scenario 'Vote for question after Cancel', js: true do
      click_on 'Vote up'
      click_on 'Cancel'
      expect(page).to have_content 'Vote up'
    end

    scenario 'show resulting rating' do
      expect(page).to have_content 'Resulting rating: 0'
    end
  end
end
