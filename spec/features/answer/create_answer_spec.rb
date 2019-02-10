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

    scenario 'answer the question with attached file' do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer!'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer!'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

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
        fill_in 'Body', with: 'text text text'
        click_on 'Answer!'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end

  end

end
