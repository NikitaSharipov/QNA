require 'rails_helper'

feature 'User can vote for the answer', %q{
  In order to emphasize the answer
  As an user
  I'd like to vote for answer
} do

  given(:user) { create :user }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Vote for question' do
    visit question_path(question)
    click_on 'Vote up'
  end

end
