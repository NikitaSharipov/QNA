require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to emphasize the question
  As an user
  I'd like to vote for question
} do

  given!(:user) { create :user }
  given!(:question) { create(:question, author: user) }

  scenario 'Vote for his answer' do
    sign_in(user)
    visit questions_path
    expect(page).to_not have_link 'Vote up'
  end

  describe "User vote for another user's question" do

    given(:another_user) { create :user}

    scenario 'Vote for question' do
      visit questions_path
      click_on 'Vote up'
    end

  end


end
