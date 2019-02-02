require 'rails_helper'

feature 'User can vote for the answer', %q{
  In order to emphasize the answer
  As an user
  I'd like to vote for answer
} do

  given(:user) { create :user }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Vote for his answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Vote up'
  end

  describe "User vote for another user's answer" do

    given(:another_user) { create :user}

    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'Vote up for answer', js: true  do
      click_on 'Vote up'
      expect(page).to have_content 'Voted with value 1'
    end

    scenario 'Vote down for answer', js: true  do
      click_on 'Vote down'
      expect(page).to have_content 'Voted with value -1'
    end

    scenario 'Vote for answer', js: true  do
      click_on 'Vote up'
      expect(page).to have_content 'Cancel'
    end

    scenario 'Can not twice vote for question' do
      click_on 'Vote up'
      expect(page).to_not have_link 'Vote up'
    end

  end

end
