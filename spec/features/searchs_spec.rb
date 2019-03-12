require 'sphinx_helper'

feature 'User can use Search', %q{
  Every user can use Search panel
  to find users, questions and etc.
} do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, author: user, title: 'test') }
  given!(:answer) { create(:answer, question: question, author: user, body: 'test')}
  given!(:comment) { create(:comment, commentable: answer, user: user, body: 'test')}



  scenario "Try to find question", js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within('.search') do
        select 'Question', from: 'category'
        fill_in 'search', with: 'test'
        click_on 'Find!'
      end

      expect(page).to have_content('test')

    end
  end
end
