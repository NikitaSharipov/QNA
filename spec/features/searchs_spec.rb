require 'sphinx_helper'

feature 'User can use Search', %q{
  Every user can use Search panel
  to find users, questions and etc.
} do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, author: user, title: 'test') }
  given!(:answer) { create(:answer, question: question, author: user, body: 'test')}
  given!(:comment) { create(:comment, commentable: answer, user: user, body: 'test')}


  %w(User Question Answer Comment).each do |klass|
    scenario "Try to find #{klass}", js: true do
      ThinkingSphinx::Test.run do
        visit questions_path

        within('.search') do
          select klass, from: 'category'
          fill_in 'search', with: 'test'
          click_on 'Find!'
        end

        expect(page).to have_content('test')

      end
    end
  end

  scenario "Try to find with Global Search", js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search') do
        select 'Global', from: 'category'
        fill_in 'search', with: 'test'
        click_on 'Find!'
      end

      expect(page).to have_content('test')

      expect(page).to have_content("Question")
      expect(page).to have_content("Answer")
      expect(page).to have_content("Comment")
    end
  end
end
