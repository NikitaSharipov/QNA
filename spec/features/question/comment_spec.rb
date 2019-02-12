require 'rails_helper'

feature 'User can see new comments in real time', %q{
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  context "multiply answers", js: true  do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your question comment', with: 'text text text'
        click_on 'Question comment!'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end

end
