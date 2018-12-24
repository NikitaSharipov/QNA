require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to solve problems
  As an user
  I'd like to be able to view all questions from a community
} do

  given!(:questions) { create_list :question, 3 }

  scenario 'User tries to see a question list' do
    visit questions_path
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
